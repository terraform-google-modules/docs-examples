resource "google_compute_health_check" "health-check-with-logging" {
  provider = google-beta

  name = "tcp-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "22"
  }

  log_config {
    enable = true
  }
}
