resource "google_healthcare_hl7_v2_store" "store" {
  name    = "example-hl7-v2-store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id

  notification_configs {
    pubsub_topic = google_pubsub_topic.topic.id
  }

  labels = {
    label1 = "labelvalue1"
  }
}

resource "google_pubsub_topic" "topic" {
  name     = "hl7-v2-notifications-${local.name_suffix}"
}

resource "google_healthcare_dataset" "dataset" {
  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}
