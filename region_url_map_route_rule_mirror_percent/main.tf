resource "google_compute_region_url_map" "regionurlmap" {
  region      = "us-central1"
  name        = "regionurlmap-${local.name_suffix}"
  description = "Test for path rule route action mirror percent"

  default_service = google_compute_region_backend_service.home.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.home.id

    path_rule {
      paths   = ["/home"]
      service = google_compute_region_backend_service.home.id
      route_action {
        request_mirror_policy {
          backend_service = google_compute_region_backend_service.mirror.id
          mirror_percent = 25.0
        }
      }
    }
  }
}

resource "google_compute_region_backend_service" "home" {
  region      = "us-central1"
  name        = "home-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "INTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_backend_service" "mirror" {
  region      = "us-central1"
  name        = "mirror-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "INTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_health_check" "default" {
  region   = "us-central1"
  name     = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
