resource "google_dataproc_metastore_service" "default" {
  service_id = "metastore-srv-${local.name_suffix}"
  location   = "us-central1"
  port       = 9080
  tier       = "DEVELOPER"

  maintenance_window {
    hour_of_day = 2
    day_of_week = "SUNDAY"
  }

  hive_metastore_config {
    version = "2.3.6"
  }
}
