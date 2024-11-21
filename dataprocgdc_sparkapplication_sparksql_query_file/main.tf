resource "google_dataproc_gdc_spark_application" "spark-application" {
  spark_application_id = "tf-e2e-sparksql-app-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
  display_name = "A SparkSql application for a Terraform create test"
  spark_sql_application_config {
    jar_file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
    query_file_uri = "gs://some-bucket/something.sql"
    script_variables = {
      "MY_VAR": "1"
    }
  }
}
