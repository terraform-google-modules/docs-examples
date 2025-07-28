resource "google_compute_target_https_proxy" "default" {
  name             = "test-fingerprint-proxy-${local.name_suffix}"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}

resource "google_compute_ssl_certificate" "default" {
  name        = "my-certificate-${local.name_suffix}"
  private_key = file("../static/ssl_cert/test.key")
  certificate = file("../static/ssl_cert/test.crt")
}

resource "google_compute_url_map" "default" {
  name        = "url-map-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.default.id
    }
  }
}

resource "google_compute_backend_service" "default" {
  name        = "backend-service-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "http-health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

output "target_https_proxy_fingerprint" {
  value       = google_compute_target_https_proxy.default.fingerprint
  description = "The fingerprint of the target HTTPS proxy for optimistic locking"
}
