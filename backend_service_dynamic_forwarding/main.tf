resource "google_compute_backend_service" "default" {
  name                  = "backend-service-${local.name_suffix}"
  load_balancing_scheme = "INTERNAL_MANAGED"
  dynamic_forwarding {
    ip_port_selection {
      enabled = true
    }
  }
}
