resource "google_redis_cluster_user_created_connections" "cluster-user-auto-conn" {
  name = "cluster-user-auto-conn-${local.name_suffix}"
  region = "us-central1"
  cluster_endpoints {
    connections {
      psc_connection {
        psc_connection_id = google_compute_forwarding_rule.forwarding_rule1_network2.psc_connection_id
        address = google_compute_address.ip1_network2.address
        forwarding_rule = google_compute_forwarding_rule.forwarding_rule1_network2.id
        network = google_compute_network.network2.id
        service_attachment = google_redis_cluster.cluster-user-auto-conn.psc_service_attachments[0].service_attachment
      }
    }
    connections {
      psc_connection {
        psc_connection_id = google_compute_forwarding_rule.forwarding_rule2_network2.psc_connection_id
        address = google_compute_address.ip2_network2.address
        forwarding_rule = google_compute_forwarding_rule.forwarding_rule2_network2.id
        network = google_compute_network.network2.id
        service_attachment = google_redis_cluster.cluster-user-auto-conn.psc_service_attachments[1].service_attachment
      }
    }
  }
}

resource "google_compute_forwarding_rule" "forwarding_rule1_network2" {
  name                   = "fwd1-net2-${local.name_suffix}"
  region                 = "us-central1"
  ip_address             = google_compute_address.ip1_network2.id
  load_balancing_scheme  = ""
  network                = google_compute_network.network2.id
  target                 = google_redis_cluster.cluster-user-auto-conn.psc_service_attachments[0].service_attachment
}

resource "google_compute_forwarding_rule" "forwarding_rule2_network2" {
  name                   = "fwd2-net2-${local.name_suffix}"
  region                 = "us-central1"
  ip_address             = google_compute_address.ip2_network2.id
  load_balancing_scheme  = ""
  network                = google_compute_network.network2.id
  target                 = google_redis_cluster.cluster-user-auto-conn.psc_service_attachments[1].service_attachment
}

resource "google_compute_address" "ip1_network2" {
  name         = "ip1-net2-${local.name_suffix}"
  region       = "us-central1"
  subnetwork   = google_compute_subnetwork.subnet_network2.id
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_address" "ip2_network2" {
  name         = "ip2-net2-${local.name_suffix}"
  region       = "us-central1"
  subnetwork   = google_compute_subnetwork.subnet_network2.id
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}

resource "google_compute_subnetwork" "subnet_network2" {
  name          = "subnet-net2-${local.name_suffix}"
  ip_cidr_range = "10.0.0.248/29"
  region        = "us-central1"
  network       = google_compute_network.network2.id
}

resource "google_compute_network" "network2" {
  name                    = "network2-${local.name_suffix}"
  auto_create_subnetworks = false
}

// redis cluster without endpoint
resource "google_redis_cluster" "cluster-user-auto-conn" {
  name           = "cluster-user-auto-conn-${local.name_suffix}"
  shard_count    = 3
  region = "us-central1"
  replica_count = 0
  deletion_protection_enabled = false
  psc_configs {
    network = google_compute_network.network1.id
  }
  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]
}

resource "google_network_connectivity_service_connection_policy" "default" {
  name = "scpolicy-${local.name_suffix}"
  location = "us-central1"
  service_class = "gcp-memorystore-redis"
  description   = "my basic service connection policy"
  network = google_compute_network.network1.id
  psc_config {
    subnetworks = [google_compute_subnetwork.subnet_network1.id]
  }
}

resource "google_compute_subnetwork" "subnet_network1" {
  name          = "subnet-net1-${local.name_suffix}"
  ip_cidr_range = "10.0.0.248/29"
  region        = "us-central1"
  network       = google_compute_network.network1.id
}

resource "google_compute_network" "network1" {
  name                    = "net1-${local.name_suffix}"
  auto_create_subnetworks = false
}
