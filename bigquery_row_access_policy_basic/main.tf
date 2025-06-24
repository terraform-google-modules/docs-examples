resource "google_bigquery_dataset" "example" {
  dataset_id = "dataset_id-${local.name_suffix}"
  location = "US"
}

resource "google_bigquery_table" "example" {
  deletion_protection = false

  dataset_id = google_bigquery_dataset.example.dataset_id
  table_id   = "table_id-${local.name_suffix}"
}

resource "google_bigquery_row_access_policy" "example" {
  dataset_id = google_bigquery_dataset.example.dataset_id
  table_id   = google_bigquery_table.example.table_id
  policy_id = "policy_id-${local.name_suffix}"

  filter_predicate = "nullable_field is not NULL"
  grantees = [
    "domain:google.com"
  ]
}
