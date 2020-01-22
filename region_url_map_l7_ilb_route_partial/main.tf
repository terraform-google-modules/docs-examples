resource "google_compute_region_url_map" "regionurlmap" {
  provider = "google-beta"
  name        = "regionurlmap-${local.name_suffix}"
  description = "a description"
  default_service = google_compute_region_backend_service.home.self_link

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name = "allpaths"
    default_service = google_compute_region_backend_service.home.self_link

    route_rules {
      priority = 1
      service = google_compute_region_backend_service.home.self_link
      header_action {
        request_headers_to_remove = ["RemoveMe2"]
      }
      match_rules {
        full_path_match = "a full path"
        header_matches {
          header_name = "someheader"
          exact_match = "match this exactly"
          invert_match = true
        }
        query_parameter_matches {
          name = "a query parameter"
          present_match = true
        }
      }
    }
  }

  test {
    service = google_compute_region_backend_service.home.self_link
    host    = "hi.com"
    path    = "/home"
  }
}

resource "google_compute_region_backend_service" "home" {
  provider = "google-beta"
  name        = "home-${local.name_suffix}"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.self_link]
  load_balancing_scheme = "INTERNAL_MANAGED"
}

resource "google_compute_region_health_check" "default" {
  provider = "google-beta"
  name               = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
