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
  description     = "URL map with expected output URL tests"
  default_service = google_compute_backend_service.backend-${local.name_suffix}.id

  test {
    description = "Test with expected output URL"
    host        = "example.com"
    path        = "/"
    service     = google_compute_backend_service.backend-${local.name_suffix}.id
    
    headers {
      name  = "User-Agent"
      value = "TestBot/1.0"
    }
    
    expected_output_url = "http://example.com/"
  }

  test {
    description = "Test API routing with expected output URL"
    host        = "api.example.com"
    path        = "/v1/users"
    service     = google_compute_backend_service.backend-${local.name_suffix}.id
    
    headers {
      name  = "Authorization"
      value = "Bearer token123"
    }
    
    expected_output_url = "http://api.example.com/v1/users"
  }
} 
