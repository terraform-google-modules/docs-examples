resource "google_compute_interconnect_group" "example-interconnect-group" {
  name   = "example-interconnect-group-${local.name_suffix}"
  intent {
    topology_capability = "NO_SLA"
  }
}
