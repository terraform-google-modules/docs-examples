resource "google_compute_interconnect_attachment" "on_prem" {
  name                     = "on-prem-attachment-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.foobar.id
  mtu                      = 1500
}

resource "google_compute_router" "foobar" {
  name    = "router-1-${local.name_suffix}"
  network = google_compute_network.foobar.name
  bgp {
    asn = 16550
  }
}

resource "google_compute_network" "foobar" {
  name                    = "network-1-${local.name_suffix}"
  auto_create_subnetworks = false
}
