resource "google_compute_region_network_endpoint_group" "region_network_endpoint_group_internet_ip_port" {
  name                  = "ip-port-neg-${local.name_suffix}"
  region                = "us-central1"
  network               = google_compute_network.default.id

  network_endpoint_type = "INTERNET_IP_PORT"
}

resource "google_compute_network" "default" {
  name                    = "network-${local.name_suffix}"
}
