resource "google_bigquery_dataset" "test" {
  dataset_id = "dataset_id-${local.name_suffix}"
}

resource "google_bigquery_connection" "test" {
  connection_id = "connection_id-${local.name_suffix}"
  location      = "US"
  spark { }
}

resource "google_bigquery_routine" "pyspark_mainfile" {
  dataset_id      = google_bigquery_dataset.test.dataset_id
  routine_id      = "routine_id-${local.name_suffix}"
  routine_type    = "PROCEDURE"
  language        = "PYTHON"
  definition_body = ""
  spark_options {
    connection      = google_bigquery_connection.test.name
    runtime_version = "2.1"
    main_file_uri   = "gs://test-bucket/main.py"
    py_file_uris    = ["gs://test-bucket/lib.py"]
    file_uris       = ["gs://test-bucket/distribute_in_executor.json"]
    archive_uris    = ["gs://test-bucket/distribute_in_executor.tar.gz"]
  }
}
