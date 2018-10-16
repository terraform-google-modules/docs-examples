resource "google_compute_health_check" "http2-health-check" {
  name = "http2-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  http2_health_check {
    port = "443"
  }
}
