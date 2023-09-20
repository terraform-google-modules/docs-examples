data "google_project" "project" {
  provider = google-beta
}

resource "google_compute_target_https_proxy" "default" {
  provider          = google-beta
  name              = "test-mtls-proxy-${local.name_suffix}"
  url_map           = google_compute_url_map.default.id
  ssl_certificates  = [google_compute_ssl_certificate.default.id]
  server_tls_policy = google_network_security_server_tls_policy.default.id
}

resource "google_certificate_manager_trust_config" "default" {
  provider    = google-beta
  name        = "my-trust-config-${local.name_suffix}"
  description = "sample description for the trust config"
  location    = "global"

  trust_stores {
    trust_anchors {
      pem_certificate = file("test-fixtures/ca_cert.pem")
    }
    intermediate_cas {
      pem_certificate = file("test-fixtures/ca_cert.pem")
    }
  }

  labels = {
    foo = "bar"
  }
}

resource "google_network_security_server_tls_policy" "default" {
  provider               = google-beta
  name                   = "my-tls-policy-${local.name_suffix}"
  description            = "my description"
  location               = "global"
  allow_open             = "false"
  mtls_policy {
    client_validation_mode = "ALLOW_INVALID_OR_MISSING_CLIENT_CERT"
    client_validation_trust_config = "projects/${data.google_project.project.number}/locations/global/trustConfigs/${google_certificate_manager_trust_config.default.name}"
  }
}

resource "google_compute_ssl_certificate" "default" {
  provider    = google-beta
  name        = "my-certificate-${local.name_suffix}"
  private_key = file("../static/ssl_cert/test.key")
  certificate = file("../static/ssl_cert/test.crt")
}

resource "google_compute_url_map" "default" {
  provider    = google-beta
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
  provider    = google-beta
  name        = "backend-service-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  provider           = google-beta
  name               = "http-health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
