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
  description     = "URL map with test headers"
  default_service = google_compute_backend_service.backend-${local.name_suffix}.id

  test {
    description = "Test with custom headers"
    host        = "example.com"
    path        = "/"
    service     = google_compute_backend_service.backend-${local.name_suffix}.id
    
    headers {
      name  = "User-Agent"
      value = "TestBot/1.0"
    }
    
    headers {
      name  = "X-Custom-Header"
      value = "test-value"
    }
  }

  test {
    description = "Test with authorization headers"
    host        = "api.example.com"
    path        = "/v1/test"
    service     = google_compute_backend_service.backend-${local.name_suffix}.id
    
    headers {
      name  = "Authorization"
      value = "Bearer token123"
    }
    
    headers {
      name  = "Content-Type"
      value = "application/json"
    }
  }
} 
