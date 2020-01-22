resource "google_compute_region_health_check" "tcp-region-health-check" {
  name     = "tcp-region-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}
