resource "google_compute_health_check" "grpc-health-check" {
  name = "grpc-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  grpc_health_check {
    port = "443"
  }
}
