resource "google_compute_backend_service" "default" {
  provider = google-beta

  name                  = "backend-service-${local.name_suffix}"
  health_checks         = [google_compute_health_check.health_check.id]
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
  locality_lb_policy    = "ROUND_ROBIN"
}

resource "google_compute_health_check" "health_check" {
  provider = google-beta

  name = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
