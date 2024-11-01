resource "google_dataproc_gdc_service_instance" "service-instance" {
  service_instance_id = "tf-e2e-service-instance-${local.name_suffix}"
  project         = "my-project-${local.name_suffix}"
  location        = "us-west2"
  gdce_cluster {
      gdce_cluster = "projects/gdce-cluster-monitoring/locations/us-west2/clusters/gdce-prism-prober-ord106"
  }
  display_name = "A service instance"
  labels = {
    "test-label": "label-value"
  }
  service_account = "dataprocgdc-cep-workflows@gdce-cluster-monitoring.iam.gserviceaccount.com"
}
