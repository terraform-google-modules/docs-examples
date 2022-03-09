resource "google_compute_region_backend_service" "default" {
  provider              = google-beta
  region                = "us-central1"
  name                  = "region-service-${local.name_suffix}"
  health_checks         = [google_compute_region_health_check.health_check.id]
  protocol              = "TCP"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_region_health_check" "health_check" {
  provider           = google-beta
  name               = "rbs-health-check-${local.name_suffix}"
  region             = "us-central1"

  tcp_health_check {
    port = 80
  }
}
