data "google_compute_node_types" "central1a" {
  zone     = "us-central1-a"
}

resource "google_compute_node_template" "template" {
  name      = "soletenant-with-disks-${local.name_suffix}"
  region    = "us-central1"
  node_type = "n2-node-80-640"

  disks {
    disk_count   = 16
    disk_size_gb = 375
    disk_type    = "local-ssd"
  }
}
