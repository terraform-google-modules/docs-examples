resource "google_compute_resource_policy" "baz" {
  name   = "policy-${local.name_suffix}"
  region = "us-central1"
  group_placement_policy {
    vm_count = 2
    collocation = "COLLOCATED"
  }
}
