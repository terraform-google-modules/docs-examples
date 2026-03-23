resource "google_workstations_workstation_cluster" "default" {
  workstation_cluster_id = "workstation-cluster-private-${local.name_suffix}"
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = "us-central1"

  private_cluster_config {
    enable_private_endpoint = true
  }

  labels = {
    "label" = "key"
  }

  annotations = {
    label-one = "value-one"
  }
}

data "google_project" "project" {
}

resource "google_compute_network" "default" {
  name                    = "workstation-cluster-private-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "workstation-cluster-private-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.default.name
}
