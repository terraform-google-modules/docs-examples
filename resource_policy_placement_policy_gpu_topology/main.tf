resource "google_compute_resource_policy" "baz" {
  name   = "gce-policy-${local.name_suffix}"
  region = "europe-west9"
  group_placement_policy {
    collocation = "COLLOCATED"
    gpu_topology = "1x72"
  }
}
