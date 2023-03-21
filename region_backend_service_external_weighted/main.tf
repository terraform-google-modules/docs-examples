resource "google_compute_region_backend_service" "default" {
  region                = "us-central1"
  name                  = "region-service-${local.name_suffix}"
  health_checks         = [google_compute_region_health_check.health_check.id]
  protocol              = "TCP"
  load_balancing_scheme = "EXTERNAL"
  locality_lb_policy    = "WEIGHTED_MAGLEV"
}

resource "google_compute_region_health_check" "health_check" {
  name               = "rbs-health-check-${local.name_suffix}"
  region             = "us-central1"

  http_health_check {
    port = 80
  }
}
