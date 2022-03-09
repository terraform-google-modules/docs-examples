resource "google_compute_subnetwork" "network-for-l7lb" {
  provider = google-beta

  name          = "l7lb-test-subnetwork-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/22"
  region        = "us-central1"
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = google_compute_network.custom-test.id
}

resource "google_compute_network" "custom-test" {
  provider = google-beta

  name                    = "l7lb-test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
