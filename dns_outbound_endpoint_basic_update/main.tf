resource "google_compute_network" "network" {
  name                    = "test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "test-subnetwork-${local.name_suffix}"
  network       = google_compute_network.network.id
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
}

resource "google_compute_subnetwork" "proxy_subnetwork" {
  name          = "test-proxy-subnetwork-${local.name_suffix}"
  network       = google_compute_network.network.id
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

resource "google_dns_outbound_endpoint" "example-endpoint" {
  name        = "example-endpoint-${local.name_suffix}"
  location    = "us-central1"
  network     = google_compute_network.network.id
  subnetwork  = google_compute_subnetwork.subnetwork.id
  endpoint_ip = "10.0.0.10"
  description = "Sample outbound endpoint description"
  labels = {
    env = "test"
  }
  annotations = {
    owner = "network-team"
  }

  depends_on = [
    google_compute_subnetwork.proxy_subnetwork
  ]
}
