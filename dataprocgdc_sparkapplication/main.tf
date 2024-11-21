resource "google_dataproc_gdc_application_environment" "app_env" {
  application_environment_id = "tf-e2e-spark-app-env-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
}

resource "google_dataproc_gdc_spark_application" "spark-application" {
  spark_application_id = "tf-e2e-spark-app-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
  labels = {
    "test-label": "label-value"
  }
  annotations = {
    "an_annotation": "annotation_value"
  }
  properties = {
    "spark.executor.instances": "2"
  }
  application_environment = google_dataproc_gdc_application_environment.app_env.name
  version = "1.2"
  spark_application_config {
    main_jar_file_uri = "file:///usr/lib/spark/examples/jars/spark-examples.jar"
    jar_file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
    archive_uris = ["file://usr/lib/spark/examples/spark-examples.jar"]
    file_uris = ["file:///usr/lib/spark/examples/jars/spark-examples.jar"]
  }
}
