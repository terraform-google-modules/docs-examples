resource "google_network_connectivity_internal_range" "default" {
  name          = "migration-${local.name_suffix}"
  description   = "Test internal range"
  network       = google_compute_network.default.self_link
  usage         = "FOR_MIGRATION"
  peering       = "FOR_SELF"
  ip_cidr_range = "10.1.0.0/16"
  migration {
    source = google_compute_subnetwork.source.self_link
    target = "projects/${data.google_project.target_project.project_id}/regions/us-central1/subnetworks/target-subnet"
  }
}

resource "google_compute_network" "default" {
  name                    = "internal-ranges-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "source" {
  name          = "source-subnet-${local.name_suffix}"
  ip_cidr_range = "10.1.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.default.name
}

data "google_project" "target_project" {
}
