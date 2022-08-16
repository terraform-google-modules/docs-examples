resource "google_dataproc_metastore_service" "aux" {
  provider   = google-beta
  service_id = "metastore-aux-${local.name_suffix}"
  location   = "us-central1"
  tier       = "DEVELOPER"

  hive_metastore_config {
    version = "3.1.2"
    auxiliary_versions {
      key     = "aux-test"
      version = "2.3.6"
    }
  }
}
