resource "google_compute_region_target_https_proxy" "default" {
  name                             = "target-http-proxy-${local.name_suffix}"
  url_map                          = google_compute_region_url_map.default.id
  certificate_manager_certificates =  ["//certificatemanager.googleapis.com/${google_certificate_manager_certificate.default.id}"] # [google_certificate_manager_certificate.default.id] is also acceptable
}

resource "google_certificate_manager_certificate" "default" {
  name              = "my-certificate-${local.name_suffix}"
  location          = "us-central1"
  self_managed {
    pem_certificate = file("test-fixtures/cert.pem")
    pem_private_key = file("test-fixtures/private-key.pem")                                                                                                                
  }
}

resource "google_compute_region_url_map" "default" {
  name            = "url-map-${local.name_suffix}"
  default_service = google_compute_region_backend_service.default.id
  region          = "us-central1"
}

resource "google_compute_region_backend_service" "default" {
  name                  = "backend-service-${local.name_suffix}"
  region                = "us-central1"
  protocol              = "HTTPS"
  timeout_sec           = 30
  load_balancing_scheme = "INTERNAL_MANAGED"
}
