resource "google_compute_region_health_check" "https-region-health-check" {
  name     = "https-region-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  https_health_check {
    port = "443"
  }
}
