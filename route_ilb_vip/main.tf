resource "google_compute_network" "producer" {
  provider                = google-beta
  name                    = "producer-${local.name_suffix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "producer" {
  provider      = google-beta
  name          = "producer-${local.name_suffix}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.producer.id
}

resource "google_compute_network" "consumer" {
  provider                = google-beta
  name                    = "consumer-${local.name_suffix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "consumer" {
  provider      = google-beta
  name          = "consumer-${local.name_suffix}-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.consumer.id
}

resource "google_compute_network_peering" "peering1" {
  provider     = google-beta
  name         = "peering-producer-${local.name_suffix}-to-consumer-${local.name_suffix}"
  network      = google_compute_network.consumer.id
  peer_network = google_compute_network.producer.id
}

resource "google_compute_network_peering" "peering2" {
  provider     = google-beta
  name         = "peering-consumer-${local.name_suffix}-to-producer-${local.name_suffix}"
  network      = google_compute_network.producer.id
  peer_network = google_compute_network.consumer.id
}

resource "google_compute_health_check" "hc" {
  provider           = google-beta
  name               = "proxy-health-check-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_region_backend_service" "backend" {
  provider      = google-beta
  name          = "compute-backend-${local.name_suffix}"
  region        = "us-central1"
  health_checks = [google_compute_health_check.hc.id]
}

resource "google_compute_forwarding_rule" "default" {
  provider = google-beta
  name     = "compute-forwarding-rule-${local.name_suffix}"
  region   = "us-central1"

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.backend.id
  all_ports             = true
  network               = google_compute_network.producer.name
  subnetwork            = google_compute_subnetwork.producer.name
}

resource "google_compute_route" "route-ilb" {
  provider     = google-beta
  name         = "route-ilb-${local.name_suffix}"
  dest_range   = "0.0.0.0/0"
  network      = google_compute_network.consumer.name
  next_hop_ilb = google_compute_forwarding_rule.default.ip_address
  priority     = 2000
  tags         = ["tag1", "tag2"]

  depends_on = [
    google_compute_network_peering.peering1,
    google_compute_network_peering.peering2
  ]
}
