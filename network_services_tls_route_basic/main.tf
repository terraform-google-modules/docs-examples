resource "google_compute_backend_service" "default" {
  name          = "my-backend-service-${local.name_suffix}"
  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "backend-service-health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_network_services_tls_route" "default" {
  name                   = "my-tls-route-${local.name_suffix}"
  description             = "my description"
  rules                   {
    matches {
      sni_host = ["example.com"]
      alpn = ["http/1.1"]
    }
    action {
      destinations {
        service_name = google_compute_backend_service.default.id
        weight = 1
      }
    }
  }
}
