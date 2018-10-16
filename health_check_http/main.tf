resource "google_compute_health_check" "http-health-check" {
  name = "http-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = 80
  }
}
