resource "google_bigquery_dataset" "test" {
	dataset_id = "dataset_id-${local.name_suffix}"
}

resource "google_bigquery_routine" "sproc" {
  dataset_id = google_bigquery_dataset.test.dataset_id
  routine_id     = "routine_id-${local.name_suffix}"
  routine_type = "PROCEDURE"
  language = "SQL"
  definition_body = "CREATE FUNCTION Add(x FLOAT64, y FLOAT64) RETURNS FLOAT64 AS (x + y);"
}
