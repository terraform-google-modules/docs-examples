resource "google_compute_address" "ipsec-interconnect-address" {
  name          = "test-address-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "IPSEC_INTERCONNECT"
  address       = "192.168.1.0"
  prefix_length = 29
  network       = google_compute_network.network.self_link
}

resource "google_compute_network" "network" {
  name                    = "test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
