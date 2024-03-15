resource "google_compute_region_url_map" "urlmap" {
  region = "us-central1"

  name        = "urlmap-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_region_backend_service.home-backend.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "mysite"
  }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_region_backend_service.home-backend.id

    route_rules {
      match_rules {
        path_template_match = "/xyzwebservices/v2/xyz/users/{username=*}/carts/{cartid=**}"
      }
      service = google_compute_region_backend_service.cart-backend.id
      priority = 1
      route_action {
        url_rewrite {
          path_template_rewrite = "/{username}-{cartid}/"
        }
      }
    }

    route_rules {
      match_rules {
        path_template_match = "/xyzwebservices/v2/xyz/users/*/accountinfo/*"
      }
      service = google_compute_region_backend_service.user-backend.id
      priority = 2
    }
  }
}

resource "google_compute_region_backend_service" "home-backend" {
  region = "us-central1"

  name        = "home-service-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_backend_service" "cart-backend" {
  region = "us-central1"

  name        = "cart-service-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_backend_service" "user-backend" {
  region = "us-central1"

  name        = "user-service-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_health_check" "default" {
  region = "us-central1"

  name               = "health-check-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1
  http_health_check {
    port         = 80
    request_path = "/"
  }
}
