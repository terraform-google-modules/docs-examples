resource "google_network_connectivity_internal_range" "default" {
  name          = "internal-address-${local.name_suffix}"
  description   = "Test internal range for internal address allocation"
  network       = google_compute_network.default.id
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  purpose       = "INTERNAL_ADDRESS"
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_network" "default" {
  name                    = "internal-ranges-${local.name_suffix}"
  auto_create_subnetworks = false
}
