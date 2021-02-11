resource "google_bigquery_table" "foo" {
  deletion_protection = false
  dataset_id = google_bigquery_dataset.bar.dataset_id
  table_id   = "job_load-${local.name_suffix}_table"
}

resource "google_bigquery_dataset" "bar" {
  dataset_id                  = "job_load-${local.name_suffix}_dataset"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "US"
}

resource "google_bigquery_job" "job" {
  job_id     = "job_load-${local.name_suffix}"

  labels = {
    "my_job" ="load"
  }

  load {
    source_uris = [
      "gs://cloud-samples-data/bigquery/us-states/us-states-by-date.csv",
    ]

    destination_table {
      table_id   = google_bigquery_table.foo.id
    }

    skip_leading_rows = 1
    schema_update_options = ["ALLOW_FIELD_RELAXATION", "ALLOW_FIELD_ADDITION"]

    write_disposition = "WRITE_APPEND"
    autodetect = true
  }
}
