resource "google_dataproc_metastore_service" "test_resource" {
  service_id = "test-service-${local.name_suffix}"
  location   = "us-central1"

  # DPMS 2 requires SPANNER database type, and does not require
  # a maintenance window.
  database_type = "SPANNER"

  hive_metastore_config {
    version           = "3.1.2"
  }

  scaling_config {
    autoscaling_config {
      autoscaling_enabled = true
      limit_config {
        min_scaling_factor = 0.1
      }
    }
  }
}
