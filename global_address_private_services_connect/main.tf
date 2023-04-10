resource "google_compute_global_address" "default" {
  provider      = google-beta
  name          = "global-psconnect-ip-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  network       = google_compute_network.network.id
  address       = "100.100.100.105"
}

resource "google_compute_network" "network" {
  provider      = google-beta
  name          = "my-network-name-${local.name_suffix}"
  auto_create_subnetworks = false
}
