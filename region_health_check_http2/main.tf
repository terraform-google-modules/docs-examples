resource "google_compute_region_health_check" "http2-region-health-check" {
  name     = "http2-region-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  http2_health_check {
    port = "443"
  }
}
