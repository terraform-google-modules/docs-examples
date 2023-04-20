resource "google_compute_backend_service" "default" {
  provider               = google-beta
  name          = "my-backend-service-${local.name_suffix}"
  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  provider               = google-beta
  name               = "backend-service-health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_network_services_gateway" "default" {
  provider    = google-beta
  name        = "my-tls-route-${local.name_suffix}"
  labels      = {
    foo = "bar"
  }
  description = "my description"
  scope = "my-scope"
  type = "OPEN_MESH"
  ports = [443]
}

resource "google_network_services_tls_route" "default" {
  provider               = google-beta
  name                   = "my-tls-route-${local.name_suffix}"
  description             = "my description"
  gateways = [
    google_network_services_gateway.default.id
  ]
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
