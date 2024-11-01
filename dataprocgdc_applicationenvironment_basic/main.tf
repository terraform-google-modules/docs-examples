resource "google_dataproc_gdc_application_environment" "application-environment" {
  application_environment_id = "dp-tf-e2e-application-environment-basic-${local.name_suffix}"
  serviceinstance = "do-not-delete-dataproc-gdc-instance"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  namespace = "default"
}
