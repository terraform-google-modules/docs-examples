resource "google_compute_target_http_proxy" "default" {
  name    = "test-https-redirect-proxy-${local.name_suffix}"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "url-map-${local.name_suffix}"
  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}
