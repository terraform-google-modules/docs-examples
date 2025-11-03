resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = google_compute_network.default.id
  }

  initial_user {
    password = "alloydb-cluster-${local.name_suffix}"
  }

  deletion_protection = false
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-cluster-${local.name_suffix}"
}
