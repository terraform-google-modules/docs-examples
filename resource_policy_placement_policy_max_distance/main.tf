resource "google_compute_resource_policy" "baz" {
  name   = "gce-policy-${local.name_suffix}"
  region = "us-central1"
  provider = google-beta
  group_placement_policy {
    vm_count = 2
    collocation = "COLLOCATED"
    max_distance = 2
  }
}
