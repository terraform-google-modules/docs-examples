resource "google_compute_target_http_proxy" "default" {
  name    = "test-fingerprint-proxy-${local.name_suffix}"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "url-map-${local.name_suffix}"
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

output "target_http_proxy_fingerprint" {
  value       = google_compute_target_http_proxy.default.fingerprint
  description = "The fingerprint of the target HTTP proxy for optimistic locking"
}
