resource "google_compute_ha_vpn_gateway" "vpn-gateway" {
  name           = "test-ha-vpngw-${local.name_suffix}"
  network        = google_compute_network.network.id
  vpn_interfaces {
      id                      = 0
      interconnect_attachment = google_compute_interconnect_attachment.attachment1.self_link
  }
  vpn_interfaces {
      id                      = 1
      interconnect_attachment = google_compute_interconnect_attachment.attachment2.self_link
  }
}

resource "google_compute_interconnect_attachment" "attachment1" {
  name                     = "test-interconnect-attachment1-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router.id
  encryption               = "IPSEC"
  ipsec_internal_addresses = [
    google_compute_address.address1.self_link,
  ]
}

resource "google_compute_interconnect_attachment" "attachment2" {
  name                     = "test-interconnect-attachment2-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_2"
  type                     = "PARTNER"
  router                   = google_compute_router.router.id
  encryption               = "IPSEC"
  ipsec_internal_addresses = [
    google_compute_address.address2.self_link,
  ]
}

resource "google_compute_address" "address1" {
  name          = "test-address1-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "IPSEC_INTERCONNECT"
  address       = "192.168.1.0"
  prefix_length = 29
  network       = google_compute_network.network.self_link
}

resource "google_compute_address" "address2" {
  name          = "test-address2-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "IPSEC_INTERCONNECT"
  address       = "192.168.2.0"
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
