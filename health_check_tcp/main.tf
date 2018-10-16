resource "google_compute_health_check" "tcp-health-check" {
  name = "tcp-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}
