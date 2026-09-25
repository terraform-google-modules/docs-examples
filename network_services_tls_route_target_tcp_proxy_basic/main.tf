resource "google_compute_backend_service" "default" {
  name                  = "my-backend-service-${local.name_suffix}"
  load_balancing_scheme = "INTERNAL_MANAGED"
  protocol              = "TCP"
  health_checks         = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name     = "my-health-check-${local.name_suffix}"

  https_health_check {
    port = 443
  }
}

resource "google_compute_target_tcp_proxy" "default" {
  name                  = "my-target-tcp-proxy-${local.name_suffix}"
  load_balancing_scheme = "INTERNAL_MANAGED"
}

resource "google_network_services_tls_route" "default" {
  name     = "my-tls-route-${local.name_suffix}"

  target_proxies = [
    google_compute_target_tcp_proxy.default.id
  ]

  rules {
    matches {
      sni_host = ["example.com"]
    }
    action {
      destinations {
        service_name = google_compute_backend_service.default.id
      }
    }
  }
}
