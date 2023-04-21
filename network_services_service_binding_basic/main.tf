resource "google_service_directory_namespace" "default" {
  provider     = google-beta
  namespace_id = "my-namespace-${local.name_suffix}"
  location     = "us-central1"
}

resource "google_service_directory_service" "default" {
  provider   = google-beta
  service_id = "my-service-${local.name_suffix}"
  namespace  = google_service_directory_namespace.default.id

  metadata = {
    stage  = "prod"
    region = "us-central1"
  }
}

resource "google_network_services_service_binding" "default" {
  provider    = google-beta
  name        = "my-service-binding-${local.name_suffix}"
  labels      = {
    foo = "bar"
  }
  description = "my description"
  service = google_service_directory_service.default.id
}
