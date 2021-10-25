resource "google_bigquery_table" "source-one" {
  deletion_protection = false
  dataset_id = google_bigquery_dataset.source-one.dataset_id
  table_id   = "job_extract-${local.name_suffix}_table"

  schema = <<EOF
[
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "post_abbr",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_dataset" "source-one" {
  dataset_id    = "job_extract-${local.name_suffix}_dataset"
  friendly_name = "test"
  description   = "This is a test description"
  location      = "US"
}

resource "google_storage_bucket" "dest" {
  name          = "job_extract-${local.name_suffix}_bucket"
  location      = "US"
  force_destroy = true
}

resource "google_bigquery_job" "job" {
  job_id     = "job_extract-${local.name_suffix}"

  extract {
    destination_uris = ["${google_storage_bucket.dest.url}/extract"]

    source_table {
      table_id   = google_bigquery_table.source-one.id
    }

    destination_format = "NEWLINE_DELIMITED_JSON"
    compression = "GZIP"
  }
}
