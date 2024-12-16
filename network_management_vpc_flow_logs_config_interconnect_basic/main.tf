data "google_project" "project" {
}

resource "google_network_management_vpc_flow_logs_config" "interconnect-test" {
  vpc_flow_logs_config_id = "basic-interconnect-test-id-${local.name_suffix}"
  location                = "global"
  interconnect_attachment = "projects/${data.google_project.project.number}/regions/us-east4/interconnectAttachments/${google_compute_interconnect_attachment.attachment.name}"
}

resource "google_compute_network" "network" {
  name     = "basic-interconnect-test-network-${local.name_suffix}"
}

resource "google_compute_router" "router" {
  name    = "basic-interconnect-test-router-${local.name_suffix}"
  network = google_compute_network.network.name
  bgp {
    asn = 16550
  }
}

resource "google_compute_interconnect_attachment" "attachment" {
  name                     = "basic-interconnect-test-id-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router.id
  mtu                      = 1500
}

