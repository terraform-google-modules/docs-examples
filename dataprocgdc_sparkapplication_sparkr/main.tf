resource "google_dataproc_gdc_spark_application" "spark-application" {
  spark_application_id = "tf-e2e-sparkr-app-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
  display_name = "A SparkR application for a Terraform create test"
  spark_r_application_config {
    main_r_file_uri = "gs://some-bucket/something.R"
    file_uris = ["file://usr/lib/spark/examples/spark-examples.jar"]
    archive_uris = ["file://usr/lib/spark/examples/spark-examples.jar"]
    args = ["10"]
  }
}
