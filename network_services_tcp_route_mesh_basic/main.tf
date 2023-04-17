resource "google_compute_backend_service" "default" {
  provider               = google-beta
  name          = "my-backend-service-${local.name_suffix}"
  health_checks = [google_compute_http_health_check.default.id]
}

resource "google_compute_http_health_check" "default" {
  provider               = google-beta
  name               = "backend-service-health-check-${local.name_suffix}"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_network_services_mesh" "default" {
  provider    = google-beta
  name        = "my-tcp-route-${local.name_suffix}"
  labels      = {
    foo = "bar"
  }
  description = "my description"
}


resource "google_network_services_tcp_route" "default" {
  provider               = google-beta
  name                   = "my-tcp-route-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description             = "my description"
  meshes = [
    google_network_services_mesh.default.id
  ]
  rules                   {
    matches {
      address = "10.0.0.1/32"
      port = "8081"
    }
    action {
      destinations {
        service_name = google_compute_backend_service.default.id
        weight = 1
      }
      original_destination = false
    }
  }
}
