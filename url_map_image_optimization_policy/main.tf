resource "google_compute_url_map" "urlmap" {
  name            = "urlmap-${local.name_suffix}"
  description     = "a description"
  default_service = google_compute_backend_service.example.id

  default_route_action {
    image_optimization_policy {
      query_parameter_interpretation = "ENABLED"
    }
  }

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "mysite-path"
  }

  host_rule {
    hosts        = ["api.mysite.com"]
    path_matcher = "mysite-route"
  }

  path_matcher {
    name            = "mysite-path"
    default_service = google_compute_backend_service.example.id

    default_route_action {
      image_optimization_policy {
        query_parameter_interpretation = "DISABLED"
      }
    }

    path_rule {
      paths   = ["/private/*"]
      service = google_compute_backend_service.example.id

      route_action {
        image_optimization_policy {
          query_parameter_interpretation = "ENABLED"
        }
      }
    }
  }

  path_matcher {
    name            = "mysite-route"
    default_service = google_compute_backend_service.example.id

    route_rules {
      priority = 1
      match_rules {
        prefix_match = "/images"
      }
      service = google_compute_backend_service.example.id

      route_action {
        image_optimization_policy {
          query_parameter_interpretation = "DISABLED"
        }
      }
    }
  }
}

resource "google_compute_backend_service" "example" {
  name                  = "example-${local.name_suffix}"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"
  enable_cdn            = true

  health_checks = [google_compute_health_check.default.id]
}

resource "google_compute_health_check" "default" {
  name = "health-check-${local.name_suffix}"
  http_health_check {
    port = 80
  }
}
