resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.id

  bigquery_config {
    table = "${google_bigquery_table.test.project}.${google_bigquery_table.test.dataset_id}.${google_bigquery_table.test.table_id}"
    service_account_email = google_service_account.bq_write_service_account.email
  }

  depends_on = [
    google_service_account.bq_write_service_account,
    google_project_iam_member.bigquery_metadata_viewer,
    google_project_iam_member.bigquery_data_editor
  ]
}

data "google_project" "project" {}

resource "google_service_account" "bq_write_service_account" {
  account_id = "example-bqw-${local.name_suffix}"
  display_name = "BQ Write Service Account"
}

resource "google_project_iam_member" "bigquery_metadata_viewer" {
  project = data.google_project.project.project_id
  role   = "roles/bigquery.metadataViewer"
  member = "serviceAccount:${google_service_account.bq_write_service_account.email}"
}

resource "google_project_iam_member" "bigquery_data_editor" {
  project = data.google_project.project.project_id
  role   = "roles/bigquery.dataEditor"
  member = "serviceAccount:${google_service_account.bq_write_service_account.email}"
}

resource "google_bigquery_dataset" "test" {
  dataset_id = "example_dataset-${local.name_suffix}"
}

resource "google_bigquery_table" "test" {
  deletion_protection = false
  table_id   = "example_table-${local.name_suffix}"
  dataset_id = google_bigquery_dataset.test.dataset_id

  schema = <<EOF
[
  {
    "name": "data",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The data"
  }
]
EOF
}
