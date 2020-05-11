resource "google_compute_region_backend_service" "default" {
  name                            = "region-service-${local.name_suffix}"
  region                          = "us-central1"
  health_checks                   = [google_compute_health_check.default.id]
  connection_draining_timeout_sec = 10
  session_affinity                = "CLIENT_IP"
}

resource "google_compute_health_check" "default" {
  name               = "rbs-health-check-${local.name_suffix}"
  check_interval_sec = 1
  timeout_sec        = 1

  tcp_health_check {
    port = "80"
  }
}
