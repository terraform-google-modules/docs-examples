resource "google_compute_network" "default" {
    name = "my-network-${local.name_suffix}"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "my-subnetwork-${local.name_suffix}"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.default.id
}

resource "google_datastream_private_connection" "private_connection" {
    display_name          = "Private connection"
    location              = "us-central1"
    private_connection_id = "my-connection-${local.name_suffix}"

    vpc_peering_config {
        vpc = google_compute_network.default.id
        subnet = "10.0.0.0/29"
    }
}

resource "google_sql_database_instance" "instance" {
    name             = "my-instance-${local.name_suffix}"
    database_version = "POSTGRES_14"
    region           = "us-central1"
    settings {
        tier = "db-f1-micro"
        ip_configuration {
            authorized_networks {
                value = google_compute_address.nat_vm_ip.address
            }
        }
    }

    deletion_protection  = false
}

resource "google_sql_database" "db" {
    instance = google_sql_database_instance.instance.name
    name     = "db"
}

resource "random_password" "pwd" {
    length = 16
    special = false
}

resource "google_sql_user" "user" {
    name = "user"
    instance = google_sql_database_instance.instance.name
    password = random_password.pwd.result
}

resource "google_compute_address" "nat_vm_ip" {
  name         = "nat-vm-ip-${local.name_suffix}"
}

resource "google_compute_instance" "nat_vm" {
  name           = "nat-vm-${local.name_suffix}"
  machine_type   = "e2-medium"
  zone           = "us-central1-a"
  desired_status  = "RUNNING"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network     = google_datastream_private_connection.private_connection.vpc_peering_config.0.vpc
    subnetwork  = google_compute_subnetwork.default.self_link
    access_config {
        nat_ip = google_compute_address.nat_vm_ip.address
    }
  }

  metadata_startup_script = <<EOT
#! /bin/bash
# See https://cloud.google.com/datastream/docs/private-connectivity#set-up-reverse-proxy
export DB_ADDR=${google_sql_database_instance.instance.public_ip_address}
export DB_PORT=5432
echo 1 > /proc/sys/net/ipv4/ip_forward
md_url_prefix="http://169.254.169.254/computeMetadata/v1/instance"
vm_nic_ip="$(curl -H "Metadata-Flavor: Google" $${md_url_prefix}/network-interfaces/0/ip)"
iptables -t nat -F
iptables -t nat -A PREROUTING \
     -p tcp --dport $DB_PORT \
     -j DNAT \
     --to-destination $DB_ADDR
iptables -t nat -A POSTROUTING \
     -p tcp --dport $DB_PORT \
     -j SNAT \
     --to-source $vm_nic_ip
iptables-save
EOT
}

resource "google_compute_firewall" "rules" {
  name        = "ingress-rule-${local.name_suffix}"
  network     = google_datastream_private_connection.private_connection.vpc_peering_config.0.vpc
  description = "Allow traffic into NAT VM"
  direction   = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = [google_datastream_private_connection.private_connection.vpc_peering_config.0.subnet]
}

resource "google_datastream_connection_profile" "default" {
    display_name          = "Connection profile"
    location              = "us-central1"
    connection_profile_id = "my-profile-${local.name_suffix}"

    postgresql_profile {
        hostname = google_compute_instance.nat_vm.network_interface.0.network_ip
        username = google_sql_user.user.name
        password = google_sql_user.user.password
        database = google_sql_database.db.name
        port = 5432
    }

    private_connectivity {
        private_connection = google_datastream_private_connection.private_connection.id
    }
}
