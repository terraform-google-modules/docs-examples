resource "google_compute_router" "encrypted-interconnect-router" {
  name                          = "test-router-${local.name_suffix}"
  network                       = google_compute_network.network.name
  encrypted_interconnect_router = true
  bgp {
    asn = 64514
  }
}

resource "google_compute_network" "network" {
  name                    = "test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
