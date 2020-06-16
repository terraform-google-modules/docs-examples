resource "google_compute_node_template" "template" {
  name      = "soletenant-tmpl-${local.name_suffix}"
  region    = "us-central1"
  node_type = "n1-node-96-624"
}
