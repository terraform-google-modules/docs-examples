resource "google_compute_health_check" "grpc-with-tls-health-check" {
  name = "grpc-with-tls-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  grpc_tls_health_check {
    port = "443"
  }
}
