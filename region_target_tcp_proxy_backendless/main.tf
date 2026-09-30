resource "google_compute_region_target_tcp_proxy" "default" {
  name                  = "test-proxy-${local.name_suffix}"
  region                = "europe-west4"
  load_balancing_scheme = "INTERNAL_MANAGED"
}
