resource "google_healthcare_dataset" "default" {
  name      = "example-dataset-${local.name_suffix}"
  location  = "us-central1"
  time_zone = "UTC"
}
