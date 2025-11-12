data "google_project" "project" {
}

resource "google_network_management_vpc_flow_logs_config" "subnet-test" {
  vpc_flow_logs_config_id = "basic-subnet-test-id-${local.name_suffix}"
  location                = "global"
  subnet                  = "projects/${data.google_project.project.number}/regions/us-central1/subnetworks/${google_compute_subnetwork.subnetwork.name}"
}

resource "google_compute_network" "network" {
  name                    = "basic-subnet-test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "basic-subnet-test-subnetwork-${local.name_suffix}"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.network.id
}
