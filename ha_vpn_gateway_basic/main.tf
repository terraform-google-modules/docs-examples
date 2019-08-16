resource "google_compute_ha_vpn_gateway" "ha_gateway1" {
  provider = "google-beta"
  region   = "us-central1"
  name     = "ha-vpn-1-${local.name_suffix}"
  network  = "${google_compute_network.network1.self_link}"
}

resource "google_compute_network" "network1" {
  provider                = "google-beta"
  name                    = "network1-${local.name_suffix}"
  auto_create_subnetworks = false
}
