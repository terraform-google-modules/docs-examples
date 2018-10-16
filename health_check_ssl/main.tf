resource "google_compute_health_check" "ssl-health-check" {
  name = "ssl-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  ssl_health_check {
    port = "443"
  }
}
