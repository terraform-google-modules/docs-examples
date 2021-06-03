resource "google_compute_interconnect_attachment" "ipsec-encrypted-interconnect-attachment" {
  name                     = "test-interconnect-attachment-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router.id
  encryption               = "IPSEC"
  ipsec_internal_addresses = [
    google_compute_address.address.self_link,
  ]
}

resource "google_compute_address" "address" {
  name          = "test-address-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "IPSEC_INTERCONNECT"
  address       = "192.168.1.0"
  prefix_length = 29
  network       = google_compute_network.network.self_link
}

resource "google_compute_router" "router" {
  name                          = "test-router-${local.name_suffix}"
  network                       = google_compute_network.network.name
  encrypted_interconnect_router = true
  bgp {
    asn = 16550
  }
}

resource "google_compute_network" "network" {
  name                    = "test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
