resource "google_compute_url_map" "urlmap" {
  name        = "urlmap-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_backend_bucket.static.id

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "mysite"
  }

  path_matcher {
    name            = "mysite"
    default_service = google_compute_backend_bucket.static.id

    route_rules {
      match_rules {
        path_template_match = "/xyzwebservices/v2/xyz/users/{username=*}/carts/{cartid=**}"
      }
      service = google_compute_backend_service.cart-backend.id
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
      service = google_compute_backend_service.user-backend.id
      priority = 2
    }
  }
}

resource "google_compute_backend_service" "cart-backend" {
  name        = "cart-service-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_backend_service" "user-backend" {
  name        = "user-service-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"

  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  name               = "health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_backend_bucket" "static" {
  name        = "static-asset-backend-bucket-${local.name_suffix}"
  bucket_name = google_storage_bucket.static.name
  enable_cdn  = true
}

resource "google_storage_bucket" "static" {
  name     = "static-asset-bucket-${local.name_suffix}"
  location = "US"
}
