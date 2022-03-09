resource "google_service_directory_namespace" "example" {
  provider     = google-beta
  namespace_id = "example-namespace-${local.name_suffix}"
  location     = "us-central1"

  labels = {
    key = "value"
    foo = "bar"
  }
}
