resource "google_bigquery_dataset" "test" {
  dataset_id = "dataset_id-${local.name_suffix}"
}

resource "google_bigquery_connection" "test" {
  connection_id = "connection_id-${local.name_suffix}"
  location      = "US"
  spark { }
}

resource "google_bigquery_routine" "spark_jar" {
  dataset_id      = google_bigquery_dataset.test.dataset_id
  routine_id      = "routine_id-${local.name_suffix}"
  routine_type    = "PROCEDURE"
  language        = "SCALA"
  definition_body = ""
  spark_options {
    connection      = google_bigquery_connection.test.name
    runtime_version = "2.1"
    container_image = "gcr.io/my-project-id/my-spark-image:latest"
    main_class      = "com.google.test.jar.MainClass"
    jar_uris        = [ "gs://test-bucket/uberjar_spark_spark3.jar" ]
    properties      = {
      "spark.dataproc.scaling.version" : "2",
      "spark.reducer.fetchMigratedShuffle.enabled" : "true",
    }
  }
}
