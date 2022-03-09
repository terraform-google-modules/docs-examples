resource "google_service_directory_namespace" "example" {
  provider     = google-beta
  namespace_id = "example-namespace-${local.name_suffix}"
  location     = "us-central1"
}

resource "google_service_directory_service" "example" {
  provider   = google-beta
  service_id = "example-service-${local.name_suffix}"
  namespace  = google_service_directory_namespace.example.id

  metadata = {
    stage  = "prod"
    region = "us-central1"
  }
}
