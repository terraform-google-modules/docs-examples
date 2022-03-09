data "google_project" "project" {
  provider  = google-beta
}

resource "google_compute_network" "example" {
  provider  = google-beta
  name      = "example-network-${local.name_suffix}"
}

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

  network = "projects/${data.google_project.project.number}/locations/global/networks/${google_compute_network.example.name}"
  address = "1.2.3.4"
  port    = 5353
}
