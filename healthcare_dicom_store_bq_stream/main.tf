resource "google_healthcare_dicom_store" "default" {
  provider = google-beta

  name    = "example-dicom-store-${local.name_suffix}"
  dataset = google_healthcare_dataset.dataset.id

  notification_config {
    pubsub_topic = google_pubsub_topic.topic.id
  }

  labels = {
    label1 = "labelvalue1"
  }

  stream_configs {
    bigquery_destination {
      table_uri = "bq://${google_bigquery_dataset.bq_dataset.project}.${google_bigquery_dataset.bq_dataset.dataset_id}.${google_bigquery_table.bq_table.table_id}"
    }
  }  
}

resource "google_pubsub_topic" "topic" {
  provider = google-beta

  name     = "dicom-notifications-${local.name_suffix}"
}

resource "google_healthcare_dataset" "dataset" {
  provider = google-beta

  name     = "example-dataset-${local.name_suffix}"
  location = "us-central1"
}

resource "google_bigquery_dataset" "bq_dataset" {
  provider = google-beta

  dataset_id    = "dicom_bq_ds-${local.name_suffix}"
  friendly_name = "test"
  description   = "This is a test description"
  location      = "US"
  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "bq_table" {
  provider = google-beta

  deletion_protection = false
  dataset_id = google_bigquery_dataset.bq_dataset.dataset_id
  table_id   = "dicom_bq_tb-${local.name_suffix}"
}
