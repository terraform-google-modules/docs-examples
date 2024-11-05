resource "google_dataproc_gdc_application_environment" "application-environment" {
  application_environment_id = "dp-tf-e2e-application-environment-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
  display_name = "An application environment"
  labels = {
    "test-label": "label-value"
  }
  annotations = {
    "an_annotation": "annotation_value"
  }
  spark_application_environment_config {
    default_properties = {
      "spark.executor.memory": "4g"
    }
    default_version = "1.2"
  }
}
