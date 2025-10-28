resource "google_compute_region_health_check" "grpc-with-tls-region-health-check" {
  name = "grpc-with-tls-region-health-check-${local.name_suffix}"
  description = "regional health check via GRPC with TLS"

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
