resource "google_compute_region_backend_service" "default" {
  region = "us-central1"
  name = "region-service-${local.name_suffix}"
  health_checks = [google_compute_health_check.health_check.id]
  protocol = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  locality_lb_policy = "ROUND_ROBIN"
}

resource "google_compute_health_check" "health_check" {
  name               = "rbs-health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
