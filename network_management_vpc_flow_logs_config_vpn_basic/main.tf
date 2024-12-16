data "google_project" "project" {
}

resource "google_network_management_vpc_flow_logs_config" "vpn-test" {
  vpc_flow_logs_config_id = "basic-test-id-${local.name_suffix}"
  location                = "global"
  vpn_tunnel              = "projects/${data.google_project.project.number}/regions/us-central1/vpnTunnels/${google_compute_vpn_tunnel.tunnel.name}"
}

resource "google_compute_vpn_tunnel" "tunnel" {
  name               = "basic-test-tunnel-${local.name_suffix}"
  peer_ip            = "15.0.0.120"
  shared_secret      = "a secret message"
  target_vpn_gateway = google_compute_vpn_gateway.target_gateway.id

  depends_on = [
    google_compute_forwarding_rule.fr_esp,
    google_compute_forwarding_rule.fr_udp500,
    google_compute_forwarding_rule.fr_udp4500,
  ]
}

resource "google_compute_vpn_gateway" "target_gateway" {
  name     = "basic-test-gateway-${local.name_suffix}"
  network  = google_compute_network.network.id
}

resource "google_compute_network" "network" {
  name     = "basic-test-network-${local.name_suffix}"
}

resource "google_compute_address" "vpn_static_ip" {
  name     = "basic-test-address-${local.name_suffix}"
}

resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "basic-test-fresp-${local.name_suffix}"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "basic-test-fr500-${local.name_suffix}"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "basic-test-fr4500-${local.name_suffix}"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.target_gateway.id
}

resource "google_compute_route" "route" {
  name                = "basic-test-route-${local.name_suffix}"
  network             = google_compute_network.network.name
  dest_range          = "15.0.0.0/24"
  priority            = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel.id
}
