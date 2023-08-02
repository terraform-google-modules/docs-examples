// Forwarding rule for Internal Load Balancing
resource "google_compute_forwarding_rule" "default" {
  name   = "ilb-ipv6-forwarding-rule-${local.name_suffix}"
  region = "us-central1"

  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.backend.id
  all_ports             = true
  network               = google_compute_network.default.name
  subnetwork            = google_compute_subnetwork.default.name
  ip_version            = "IPV6"
}

resource "google_compute_region_backend_service" "backend" {
  name          = "ilb-ipv6-backend-${local.name_suffix}"
  region        = "us-central1"
  health_checks = [google_compute_health_check.hc.id]
}

resource "google_compute_health_check" "hc" {
  name               = "check-ilb-ipv6-backend-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_network" "default" {
  name                    = "net-ipv6-${local.name_suffix}"
  auto_create_subnetworks = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "default" {
  name          = "subnet-internal-ipv6-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL"
  network       = google_compute_network.default.id
}
