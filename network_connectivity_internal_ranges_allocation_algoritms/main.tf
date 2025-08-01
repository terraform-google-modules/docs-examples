resource "google_network_connectivity_internal_range" "default" {
  name    = "allocation-algorithms-${local.name_suffix}"
  network = google_compute_network.default.id
  usage   = "FOR_VPC"
  peering = "FOR_SELF"
  prefix_length = 24
  target_cidr_range = [
    "192.16.0.0/16"
  ]
  allocation_options {
    allocation_strategy = "FIRST_SMALLEST_FITTING"
  }
}

resource "google_compute_network" "default" {
  name                    = "internal-ranges-${local.name_suffix}"
  auto_create_subnetworks = false
}
