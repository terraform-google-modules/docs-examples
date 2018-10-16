resource "google_compute_region_url_map" "regionurlmap" {
  provider = google-beta

  region = "us-central1"

  name        = "regionurlmap-${local.name_suffix}"
  description = "a description"

  default_service = google_compute_region_backend_service.home.self_link

  host_rule {
    hosts        = ["mysite.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.home.self_link

    path_rule {
      paths   = ["/home"]
      service = google_compute_region_backend_service.home.self_link
    }

    path_rule {
      paths   = ["/login"]
      service = google_compute_region_backend_service.login.self_link
    }
  }

  test {
    service = google_compute_region_backend_service.home.self_link
    host    = "hi.com"
    path    = "/home"
  }
}

resource "google_compute_region_backend_service" "login" {
  provider = google-beta

  region = "us-central1"

  name        = "login-${local.name_suffix}"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.self_link]
}

resource "google_compute_region_backend_service" "home" {
  provider = google-beta

  region = "us-central1"

  name        = "home-${local.name_suffix}"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.self_link]
}

resource "google_compute_region_health_check" "default" {
  provider = google-beta

  region = "us-central1"

  name               = "health-check-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1
  http_health_check {
    port         = 80
    request_path = "/"
  }
}
