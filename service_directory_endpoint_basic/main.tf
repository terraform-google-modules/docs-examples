resource "google_service_directory_namespace" "example" {
  provider     = google-beta
  namespace_id = "example-namespace-${local.name_suffix}"
  location     = "us-central1"
}

resource "google_service_directory_service" "example" {
  provider   = google-beta
  service_id = "example-service-${local.name_suffix}"
  namespace  = google_service_directory_namespace.example.id
}

resource "google_service_directory_endpoint" "example" {
  provider    = google-beta
  endpoint_id = "example-endpoint-${local.name_suffix}"
  service     = google_service_directory_service.example.id

  metadata = {
    stage  = "prod"
    region = "us-central1"
  }

  address = "1.2.3.4"
  port    = 5353
}
