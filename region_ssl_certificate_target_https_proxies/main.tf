// Using with Region Target HTTPS Proxies
//
// SSL certificates cannot be updated after creation. In order to apply
// the specified configuration, Terraform will destroy the existing
// resource and create a replacement. To effectively use an SSL
// certificate resource with a Target HTTPS Proxy resource, it's
// recommended to specify create_before_destroy in a lifecycle block.
// Either omit the Instance Template name attribute, specify a partial
// name with name_prefix, or use random_id resource. Example:

resource "google_compute_region_ssl_certificate" "default" {
  provider    = google-beta
  region      = "us-central1"
  name_prefix = "my-certificate-"
  private_key = file("../static/ssl_cert/test.key")
  certificate = file("../static/ssl_cert/test.crt")

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_target_https_proxy" "default" {
  provider         = google-beta
  region           = "us-central1"
  name             = "test-proxy-${local.name_suffix}"
  url_map          = google_compute_region_url_map.default.self_link
  ssl_certificates = [google_compute_region_ssl_certificate.default.self_link]
}

resource "google_compute_region_url_map" "default" {
  provider    = google-beta
  region      = "us-central1"
  name        = "url-map-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_region_backend_service.default.self_link

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.default.self_link

    path_rule {
      paths   = ["/*"]
      service = google_compute_region_backend_service.default.self_link
    }
  }
}

resource "google_compute_region_backend_service" "default" {
  provider    = google-beta
  region      = "us-central1"
  name        = "backend-service-${local.name_suffix}"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.self_link]
}

resource "google_compute_region_health_check" "default" {
  provider = google-beta
  region   = "us-central1"
  name     = "http-health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
