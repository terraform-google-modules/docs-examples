resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.id

  bigquery_config {
    table = "${google_bigquery_table.test.project}.${google_bigquery_table.test.dataset_id}.${google_bigquery_table.test.table_id}"
  }
}

data "google_project" "project" {}

resource "google_bigquery_dataset" "test" {
  dataset_id = "example_dataset-${local.name_suffix}"
}

resource "google_bigquery_table" "test" {
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

  deletion_protection = false
}
