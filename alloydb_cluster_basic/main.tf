resource "google_alloydb_cluster" "default" {
  provider   = google-beta
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network    = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.default.name}"
}

data "google_project" "project" {
  provider = google-beta
}

resource "google_compute_network" "default" {
  provider = google-beta
  name = "alloydb-cluster-${local.name_suffix}"
}
