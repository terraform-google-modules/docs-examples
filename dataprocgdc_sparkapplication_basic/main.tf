resource "google_dataproc_gdc_spark_application" "spark-application" {
  spark_application_id = "tf-e2e-spark-app-basic-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
  spark_application_config {
    main_class = "org.apache.spark.examples.SparkPi"
    jar_file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
    args = ["10000"]
  }
}
