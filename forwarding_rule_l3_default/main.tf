resource "google_compute_forwarding_rule" "fwd_rule" {
  provider        = google-beta
  name            = "l3-forwarding-rule-${local.name_suffix}"
  backend_service = google_compute_region_backend_service.service.id
  ip_protocol     = "L3_DEFAULT"
  all_ports       = true
}

resource "google_compute_region_backend_service" "service" {
  provider              = google-beta
  region                = "us-central1"
  name                  = "service-${local.name_suffix}"
  health_checks         = [google_compute_region_health_check.health_check.id]
  protocol              = "UNSPECIFIED"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_region_health_check" "health_check" {
  provider           = google-beta
  name               = "health-check-${local.name_suffix}"
  region             = "us-central1"

  tcp_health_check {
    port = 80
  }
}
