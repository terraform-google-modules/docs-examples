resource "google_compute_ha_vpn_gateway" "ha_gateway1" {
  region   = "us-central1"
  name     = "ha-vpn-1-${local.name_suffix}"
  network  = google_compute_network.network1.id
}

resource "google_compute_network" "network1" {
  name                    = "network1-${local.name_suffix}"
  auto_create_subnetworks = false
}
