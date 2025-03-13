resource "google_compute_backend_service" "default" {
  name          = "backend-service-${local.name_suffix}"
  health_checks = [google_compute_health_check.default.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol = "HTTPS"
  tls_settings {
    sni = "example.com"
    subjectAltNames = [
      {
        dns_name = "example.com"
      },
      {
        uniform_resource_identifier = "https://example.com"
      }
    ]
    authentication_config = [google_network_security_backend_authentication_config.default.id]
  }
}

resource "google_compute_health_check" "default" {
  name = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}

resource "google_network_security_backend_authentication_config" "default" {
  name             = "authentication-${local.name_suffix}"
  well_known_roots = "PUBLIC_ROOTS"
}
