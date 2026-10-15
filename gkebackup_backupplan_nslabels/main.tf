resource "google_gke_backup_backup_plan" "nslabels" {
  name = "nslabels-plan-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/nslabels-cluster-${local.name_suffix}"
  location = "us-east1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    selected_namespace_labels {
      resource_labels {
        key = "key1"
        value ="value1"
     }
    }
  }
}
