resource "google_compute_health_check" "health-check-${local.name_suffix}" {
  name               = "health-check-${local.name_suffix}"
  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_backend_service" "backend-${local.name_suffix}" {
  name        = "backend-${local.name_suffix}"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_health_check.health-check-${local.name_suffix}.id]
}

resource "google_compute_url_map" "urlmap" {
  name            = "urlmap-${local.name_suffix}"
  description     = "URL map with redirect response code tests"
  default_service = google_compute_backend_service.backend-${local.name_suffix}.id

  host_rule {
    hosts        = ["example.com"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backend-${local.name_suffix}.id

    path_rule {
      paths = ["/redirect/*"]
      url_redirect {
        host_redirect          = "newsite.com"
        path_redirect          = "/new-path/"
        https_redirect         = true
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
        strip_query           = false
      }
    }
  }

  test {
    description = "Test redirect with expected response code"
    host        = "example.com"
    path        = "/redirect/old-page"
    
    headers {
      name  = "Referer"
      value = "https://oldsite.com"
    }
    
    expected_output_url              = "https://newsite.com/new-path/"
    expected_redirect_response_code  = 301
  }

  test {
    description = "Test another redirect scenario"
    host        = "example.com"
    path        = "/redirect/another-page"
    
    headers {
      name  = "User-Agent"
      value = "TestBot/1.0"
    }
    
    expected_output_url              = "https://newsite.com/new-path/"
    expected_redirect_response_code  = 301
  }
} 
