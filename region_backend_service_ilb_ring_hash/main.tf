resource "google_compute_region_backend_service" "default" {
  region = "us-central1"
  name = "region-service-${local.name_suffix}"
  health_checks = [google_compute_health_check.health_check.id]
  load_balancing_scheme = "INTERNAL_MANAGED"
  locality_lb_policy = "RING_HASH"
  session_affinity = "HTTP_COOKIE"
  protocol = "HTTP"
  circuit_breakers {
    max_connections = 10
  }
  consistent_hash {
    http_cookie {
      ttl {
        seconds = 11
        nanos = 1111
      }
      name = "mycookie"
    }
  }
  outlier_detection {
    consecutive_errors = 2
  }
}

resource "google_compute_health_check" "health_check" {
  name               = "rbs-health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
