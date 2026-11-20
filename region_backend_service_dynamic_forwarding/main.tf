resource "google_compute_region_backend_service" "default" {
  name                            = "region-service-${local.name_suffix}"
  region                          = "us-central1"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  dynamic_forwarding {
    ip_port_selection {
      enabled = true
    }
  }
}
