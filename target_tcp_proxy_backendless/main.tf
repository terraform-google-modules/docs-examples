resource "google_compute_target_tcp_proxy" "default" {
  name                  = "test-proxy-${local.name_suffix}"
  load_balancing_scheme = "INTERNAL_MANAGED"
}
