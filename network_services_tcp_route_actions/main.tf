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

resource "google_network_services_tcp_route" "default" {
  name                   = "my-tcp-route-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description             = "my description"
  rules                   {
    action {
      destinations {
        service_name = google_compute_backend_service.default.id
        weight = 1
      }
      original_destination = false
      idle_timeout = "60s"
    }
  }
}
