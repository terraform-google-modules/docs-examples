resource "google_compute_region_backend_service" "default" {
  name        = "my-backend-service-${local.name_suffix}"
  protocol    = "TCP"
  timeout_sec = 10
  region      = "europe-west4"

  health_checks         = [google_compute_region_health_check.default.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_region_health_check" "default" {
  name               = "backend-service-health-check-${local.name_suffix}"
  region             = "europe-west4"
  timeout_sec        = 1
  check_interval_sec = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_network_services_tls_route" "default" {
  name     = "my-tls-route-${local.name_suffix}"
  location = "europe-west4"
  rules {
    matches {
      sni_host = ["example.com"]
    }
    action {
      destinations {
        service_name = google_compute_region_backend_service.default.self_link
      }
    }
  }
}
