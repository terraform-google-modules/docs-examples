resource "google_dataproc_metastore_service" "metadata" {
  service_id = "metastore-metadata-${local.name_suffix}"
  location   = "us-central1"
  tier       = "DEVELOPER"

  metadata_integration {
    data_catalog_config {
      enabled = true
    }
  }

  hive_metastore_config {
    version = "3.1.2"
  }
}
