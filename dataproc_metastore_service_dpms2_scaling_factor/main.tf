resource "google_dataproc_metastore_service" "dpms2_scaling_factor" {
  service_id = "ms-dpms2sf-${local.name_suffix}"
  location   = "us-central1"

  # DPMS 2 requires SPANNER database type, and does not require
  # a maintenance window.
  database_type = "SPANNER"

  hive_metastore_config {
    version           = "3.1.2"
  }

  scaling_config {
    scaling_factor = "2"
  }
}
