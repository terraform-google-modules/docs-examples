resource "google_compute_health_check" "https-health-check" {
  name = "https-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  https_health_check {
    port = "443"
  }
}
