resource "google_compute_region_health_check" "http-region-health-check" {
  provider = google-beta

  name = "http-region-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = "80"
  }

  log_config {
    enable = true
  }
}
