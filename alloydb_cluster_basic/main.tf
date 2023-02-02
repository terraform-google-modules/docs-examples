resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network    = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-cluster-${local.name_suffix}"
}
