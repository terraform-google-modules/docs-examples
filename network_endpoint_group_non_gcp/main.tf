resource "google_compute_network_endpoint_group" "neg" {
  name                  = "my-lb-neg-${local.name_suffix}"
  network               = google_compute_network.default.id
  default_port          = "90"
  zone                  = "us-central1-a"
  network_endpoint_type = "NON_GCP_PRIVATE_IP_PORT"
}

resource "google_compute_network_endpoint" "default-endpoint" {
  network_endpoint_group = google_compute_network_endpoint_group.neg.name
  port = google_compute_network_endpoint_group.neg.default_port
  ip_address = "127.0.0.1"
}

resource "google_compute_network" "default" {
  name = "neg-network-${local.name_suffix}"
}
