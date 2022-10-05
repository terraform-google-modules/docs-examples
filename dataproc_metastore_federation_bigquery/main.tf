resource "google_dataproc_metastore_federation" "default" {
  provider      = google-beta
  location      = "us-central1"
  federation_id = "fed-2-${local.name_suffix}"
  version       = "3.1.2"

  backend_metastores {
    rank           = "2"
    name           = data.google_project.project.id
    metastore_type = "BIGQUERY" 
  }

  backend_metastores {
    rank           = "1"
    name           = google_dataproc_metastore_service.default.id
    metastore_type = "DATAPROC_METASTORE" 
  }
}

resource "google_dataproc_metastore_service" "default" {
  provider   = google-beta
  service_id = "fed-2-${local.name_suffix}"
  location   = "us-central1"
  tier       = "DEVELOPER"


  hive_metastore_config {
    version           = "3.1.2"
    endpoint_protocol = "GRPC"
  }
}

data "google_project" "project" {
  provider      = google-beta
}
