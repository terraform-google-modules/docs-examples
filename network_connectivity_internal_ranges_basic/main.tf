resource "google_network_connectivity_internal_range" "default" {
  name    = "basic-${local.name_suffix}"
  description = "Test internal range"
  network = google_compute_network.default.self_link
  usage   = "FOR_VPC"
  peering = "FOR_SELF"
  ip_cidr_range = "10.0.0.0/24"

  labels  = {
    label-a: "b"
  }
}

resource "google_compute_network" "default" {
  name                    = "internal-ranges-${local.name_suffix}"
  auto_create_subnetworks = false
}
