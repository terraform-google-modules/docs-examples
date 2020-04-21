resource "google_healthcare_fhir_store" "default" {
  name    = "example-fhir-store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id
  version = "R4"

  enable_update_create          = false
  disable_referential_integrity = false
  disable_resource_versioning   = false
  enable_history_import         = false

  notification_config {
    pubsub_topic = google_pubsub_topic.topic.id
  }

  labels = {
    label1 = "labelvalue1"
  }
}

resource "google_pubsub_topic" "topic" {
  name     = "fhir-notifications-${local.name_suffix}"
}

resource "google_healthcare_dataset" "dataset" {
  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}
