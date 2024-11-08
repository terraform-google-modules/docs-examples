resource "google_dataproc_gdc_spark_application" "spark-application" {
  spark_application_id = "tf-e2e-pyspark-app-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
  display_name = "A Pyspark application for a Terraform create test"
  dependency_images = ["gcr.io/some/image"]
  pyspark_application_config {
    main_python_file_uri = "gs://goog-dataproc-initialization-actions-us-west2/conda/test_conda.py"
    jar_file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
    python_file_uris = ["gs://goog-dataproc-initialization-actions-us-west2/conda/get-sys-exec.py"]
    file_uris = ["file://usr/lib/spark/examples/spark-examples.jar"]
    archive_uris = ["file://usr/lib/spark/examples/spark-examples.jar"]
    args = ["10"]
  }
}
