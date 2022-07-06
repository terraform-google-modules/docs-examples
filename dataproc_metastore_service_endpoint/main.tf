resource "google_dataproc_metastore_service" "endpoint" {
  provider   = google-beta
  service_id = "metastore-endpoint-${local.name_suffix}"
  location   = "us-central1"
  tier       = "DEVELOPER"

  hive_metastore_config {
    version           = "3.1.2"
    endpoint_protocol = "GRPC"
  }
}
