data "google_project" "project" {
}

resource "google_network_management_vpc_flow_logs_config" "interconnect-test" {
  vpc_flow_logs_config_id = "full-interconnect-test-id-${local.name_suffix}"
  location                = "global"
  interconnect_attachment = "projects/${data.google_project.project.number}/regions/us-east4/interconnectAttachments/${google_compute_interconnect_attachment.attachment.name}"
  state                   = "ENABLED"
  aggregation_interval    = "INTERVAL_5_SEC"
  description             = "VPC Flow Logs over a VPN Gateway."
  flow_sampling           = 0.5
  metadata                = "INCLUDE_ALL_METADATA"
}

resource "google_compute_network" "network" {
  name     = "full-interconnect-test-network-${local.name_suffix}"
}

resource "google_compute_router" "router" {
  name    = "full-interconnect-test-router-${local.name_suffix}"
  network = google_compute_network.network.name
  bgp {
    asn = 16550
  }
}

resource "google_compute_interconnect_attachment" "attachment" {
  name                     = "full-interconnect-test-id-${local.name_suffix}"
  edge_availability_domain = "AVAILABILITY_DOMAIN_1"
  type                     = "PARTNER"
  router                   = google_compute_router.router.id
  mtu                      = 1500
}

