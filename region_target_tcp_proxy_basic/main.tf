resource "google_compute_region_target_tcp_proxy" "default" {
  name            = "test-proxy-${local.name_suffix}"
  region          = "europe-west4"
  backend_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_backend_service" "default" {
  name        = "backend-service-${local.name_suffix}"
  protocol    = "TCP"
  timeout_sec = 10
  region      = "europe-west4"

  health_checks         = [google_compute_region_health_check.default.id]
  load_balancing_scheme = "INTERNAL_MANAGED"
}

resource "google_compute_region_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  region             = "europe-west4"
  timeout_sec        = 1
  check_interval_sec = 1
  
  tcp_health_check {
    port = "80"
  }
}
