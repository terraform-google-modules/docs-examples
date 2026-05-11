resource "google_workstations_workstation_cluster" "default" {
  workstation_cluster_id = "custom-urls-cluster"
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = "us-central1"

  workstation_authorization_url = "https://workstations.cloud.google.com/ui/auth"
  workstation_launch_url        = "https://console.cloud.google.com/workstations/launch"
}

data "google_project" "project" {
}

resource "google_compute_network" "default" {
  name                    = "workstations-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "workstations-network-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.name
}
