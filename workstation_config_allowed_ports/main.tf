resource "google_tags_tag_key" "tag_key1" {
  parent     = "organizations/123456789-${local.name_suffix}"
  short_name = "keyname-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value1" {
  parent     = google_tags_tag_key.tag_key1.id
  short_name = "valuename-${local.name_suffix}"
}

resource "google_compute_network" "default" {
  name                    = "workstation-cluster-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "workstation-cluster-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-west4"
  network       = google_compute_network.default.name
}

resource "google_workstations_workstation_cluster" "default" {
  workstation_cluster_id = "workstation-cluster-${local.name_suffix}"
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = "us-west4"

  labels = {
    "label" = "key"
  }

  annotations = {
    label-one = "value-one"
  }
}

resource "google_service_account" "default" {
  account_id   = "my-account-${local.name_suffix}"
  display_name = "Service Account"
}

resource "google_workstations_workstation_config" "default" {
  workstation_config_id   = "workstation-config-${local.name_suffix}"
  workstation_cluster_id  = google_workstations_workstation_cluster.default.workstation_cluster_id
  location                = "us-west4"
  display_name            = "Display Name N2"
  idle_timeout            = "600s"
  running_timeout         = "21600s"
  replica_zones           = ["us-west4-a", "us-west4-b"]
  disable_tcp_connections = false
  max_usable_workstations = 1

  annotations = {
    label-one = "value-one"
  }

  labels = {
    "label" = "key"
  }

  readiness_checks {
    path = "/healthz"
    port = 8080
  }

  # Allow only port 80 (HTTP)
  allowed_ports {
    first = 80
    last  = 80
  }

  # Allow only port 22 (SSH)
  allowed_ports {
    first = 22
    last  = 22
  }

  # Allow port range 1024-65535
  allowed_ports {
    first = 1024
    last  = 65535
  }

  container {
    image       = "us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest"
  }

  host {
    gce_instance {
      machine_type                = "e2-standard-4"
      boot_disk_size_gb           = 35
      disable_public_ip_addresses = true
      disable_ssh                 = false
      vm_tags = {
        (google_tags_tag_key.tag_key1.id) = google_tags_tag_value.tag_value1.id
      }
      instance_metadata = {
        "startup-key" = "startup-value-changed"
        "second-key"  = "second-value"
      }
    }
  }
}
