resource "google_vertex_ai_index_endpoint" "index_endpoint" {
  display_name = "sample-endpoint"
  description  = "A sample vertex endpoint"
  region       = "us-central1"
  labels       = {
    label-one = "value-one"
  }
  network      = "projects/${data.google_project.project.number}/global/networks/${data.google_compute_network.vertex_network.name}"
}

data "google_compute_network" "vertex_network" {
  name       = "network-name-${local.name_suffix}"
}

data "google_project" "project" {}
