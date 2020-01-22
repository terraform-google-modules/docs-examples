resource "google_compute_region_health_check" "ssl-region-health-check" {
  name     = "ssl-region-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  ssl_health_check {
    port = "443"
  }
}
