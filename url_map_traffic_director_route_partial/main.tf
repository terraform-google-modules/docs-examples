resource "google_compute_url_map" "urlmap" {
  name        = "urlmap-${local.name_suffix}"
  description = "a description"
  default_service = google_compute_backend_service.home.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name = "allpaths"
    default_service = google_compute_backend_service.home.id

    route_rules {
      priority = 1
      match_rules {
        prefix_match = "/someprefix"
        header_matches {
          header_name = "someheader"
          exact_match = "match this exactly"
          invert_match = true
        }
      }
      url_redirect {
        path_redirect = "some/path"
        redirect_response_code = "TEMPORARY_REDIRECT"
      }
    }
  }

  test {
    service = google_compute_backend_service.home.id
    host    = "hi.com"
    path    = "/home"
  }
}

resource "google_compute_backend_service" "home" {
  name        = "home-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_health_check.default.id]
  load_balancing_scheme = "INTERNAL_SELF_MANAGED"
}

resource "google_compute_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
