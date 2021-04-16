resource "google_compute_region_target_https_proxy" "default" {
  region           = "us-central1"
  name             = "test-proxy-${local.name_suffix}"
  url_map          = google_compute_region_url_map.default.id
  ssl_certificates = [google_compute_region_ssl_certificate.default.id]
}

resource "google_compute_region_ssl_certificate" "default" {
  region      = "us-central1"
  name        = "my-certificate-${local.name_suffix}"
  private_key = file("../static/ssl_cert/test.key")
  certificate = file("../static/ssl_cert/test.crt")
}

resource "google_compute_region_url_map" "default" {
  region      = "us-central1"
  name        = "url-map-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_region_backend_service.default.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.default.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_region_backend_service.default.id
    }
  }
}

resource "google_compute_region_backend_service" "default" {
  region      = "us-central1"
  name        = "backend-service-${local.name_suffix}"
  protocol    = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_health_check" "default" {
  region = "us-central1"
  name   = "http-health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
