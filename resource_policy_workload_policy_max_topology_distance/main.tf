resource "google_compute_resource_policy" "bar" {
  name   = "gce-policy-${local.name_suffix}"
  region = "europe-west1"
  workload_policy {
    type = "HIGH_THROUGHPUT"
    max_topology_distance = "BLOCK"
  }
}
