resource "google_compute_region_network_endpoint" "region-internet-fqdn-port-endpoint" {
  region_network_endpoint_group = google_compute_region_network_endpoint_group.group.name
  region                = "us-central1"

  fqdn  = "backend.example.com"
  port        = 443
}


resource "google_compute_region_network_endpoint_group" "group" {
  name         = "fqdn-port-neg-${local.name_suffix}"
  network      = google_compute_network.default.id

  region         = "us-central1"
  network_endpoint_type = "INTERNET_FQDN_PORT"
}

resource "google_compute_network" "default" {
  name                    = "network-${local.name_suffix}"
  auto_create_subnetworks = false
}
