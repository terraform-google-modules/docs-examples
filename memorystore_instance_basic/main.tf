resource "google_memorystore_instance" "instance-basic" {
  instance_id = "basic-instance-${local.name_suffix}"
  shard_count = 1
  desired_auto_created_endpoints {
    network    = google_compute_network.producer_net.id
    project_id = data.google_project.project.project_id
  }
  location                    = "us-central1"
  deletion_protection_enabled = false
  maintenance_policy {
    weekly_maintenance_window {
      day = "MONDAY"
      start_time {
        hours = 1
        minutes = 0
        seconds = 0
        nanos = 0
      }
    }
  }
  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]

  lifecycle {
    prevent_destroy = "true-${local.name_suffix}"
  }
}

resource "google_network_connectivity_service_connection_policy" "default" {
  name          = "my-policy-${local.name_suffix}"
  location      = "us-central1"
  service_class = "gcp-memorystore"
  description   = "my basic service connection policy"
  network       = google_compute_network.producer_net.id
  psc_config {
    subnetworks = [google_compute_subnetwork.producer_subnet.id]
  }
}

resource "google_compute_subnetwork" "producer_subnet" {
  name          = "my-subnet-${local.name_suffix}"
  ip_cidr_range = "10.0.0.248/29"
  region        = "us-central1"
  network       = google_compute_network.producer_net.id
}

resource "google_compute_network" "producer_net" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

data "google_project" "project" {
}
