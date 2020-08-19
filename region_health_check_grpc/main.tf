resource "google_compute_region_health_check" "grpc-region-health-check" {
  name = "grpc-region-health-check-${local.name_suffix}"

  timeout_sec        = 1
  check_interval_sec = 1

  grpc_health_check {
    port = "443"
  }
}
