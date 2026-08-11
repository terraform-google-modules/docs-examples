resource "google_compute_backend_service" "default" {
  name          = "backend-service-${local.name_suffix}"
  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1
  http_health_check {
    port         = 80
    request_path = "/"
  }
}
