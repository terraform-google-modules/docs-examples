resource "google_compute_backend_service" "default" {
  name = "backend-service-${local.name_suffix}"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address_selection_policy = "IPV6_ONLY"
}
