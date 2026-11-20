resource "google_compute_region_backend_service" "default" {
  name                            = "region-service-${local.name_suffix}"
  region                          = "us-central1"
  load_balancing_scheme           = "INTERNAL_SELF_MANAGED"
  protocol                        = "HTTP2"
  dynamic_forwarding {
    forward_proxy {
      enabled = true
      proxy_mode = "DIRECT_FORWARDING"
    }
  }
}
