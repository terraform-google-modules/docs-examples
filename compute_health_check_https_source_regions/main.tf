resource "google_compute_health_check" "https-health-check-with-source-regions" {
  name = "https-health-check-${local.name_suffix}"
  check_interval_sec = 30

  https_health_check {
    port = 80
    port_specification = "USE_FIXED_PORT"
  }

  source_regions = ["us-west1", "us-central1", "us-east5"]
}
