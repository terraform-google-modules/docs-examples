resource "google_compute_health_check" "grpc-with-tls-health-check" {
  name        = "grpc-with-tls-health-check-${local.name_suffix}"
  description = "Health check via grpc with TLS"

  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 4
  unhealthy_threshold = 5

  grpc_tls_health_check {
    port_specification = "USE_FIXED_PORT"
    port = "443"
    grpc_service_name  = "testservice"
  }
}
