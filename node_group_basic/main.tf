resource "google_compute_node_template" "soletenant-tmpl" {
  name      = "soletenant-tmpl-${local.name_suffix}"
  region    = "us-central1"
  node_type = "c2-node-60-240"
}

resource "google_compute_node_group" "nodes" {
  name        = "soletenant-group-${local.name_suffix}"
  zone        = "us-central1-c"
  description = "example google_compute_node_group for Terraform Google Provider"

  initial_size          = 1
  node_template = google_compute_node_template.soletenant-tmpl.id
}
