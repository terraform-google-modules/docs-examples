resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network    = google_compute_network.default.id
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-cluster-${local.name_suffix}"
}
