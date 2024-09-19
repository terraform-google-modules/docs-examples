resource "google_network_connectivity_hub" "basic_hub" {
  name        = "basic-hub1-${local.name_suffix}"
  description = "A sample hub"
  labels = {
    label-two = "value-one"
  }
}

resource "google_compute_network" "network" {
  name                    = "basic-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_router" "router" {
  name    = "external-vpn-gateway-${local.name_suffix}"
  region  = "us-central1"
  network = google_compute_network.network.name
  bgp {
    asn = 16550
  }
}

resource "google_compute_interconnect_attachment" "interconnect-attachment" {
  name                     = "partner-interconnect1-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router.id
  mtu                      = 1500
  region                   = "us-central1"
}

resource "google_network_connectivity_spoke" "primary" {
  name        = "interconnect-attachment-spoke-${local.name_suffix}"
  location    = "us-central1"
  description = "A sample spoke with a linked Interconnect Attachment"
  labels = {
    label-one = "value-one"
  }
  hub = google_network_connectivity_hub.basic_hub.id
  linked_interconnect_attachments {
    uris                       = [google_compute_interconnect_attachment.interconnect-attachment.self_link]
    site_to_site_data_transfer = true
    include_import_ranges      = ["ALL_IPV4_RANGES"]
  }
}
