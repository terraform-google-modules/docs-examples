data "google_compute_node_types" "central1a" {
  zone     = "us-central1-a"
}

resource "google_compute_node_template" "template" {
  name      = "soletenant-with-accelerators-${local.name_suffix}"
  region    = "us-central1"
  node_type = "n1-node-96-624"

  accelerators {
    accelerator_type  = "nvidia-tesla-t4"
    accelerator_count = 4
  }
}
