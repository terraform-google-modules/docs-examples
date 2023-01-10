resource "google_dataproc_metastore_service" "telemetry" {
  service_id = "telemetry-${local.name_suffix}"
  location   = "us-central1"
  port       = 9080
  tier       = "DEVELOPER"

  hive_metastore_config {
    version = "3.1.2"
  }

  telemetry_config {
    log_format = "LEGACY"
  }
}
