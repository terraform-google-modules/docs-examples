resource "google_healthcare_dicom_store" "default" {
  name    = "example-dicom-store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id

  notification_config {
    pubsub_topic = google_pubsub_topic.topic.id
  }

  labels = {
    label1 = "labelvalue1"
  }
}

resource "google_pubsub_topic" "topic" {
  name     = "dicom-notifications-${local.name_suffix}"
}

resource "google_healthcare_dataset" "dataset" {
  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}
