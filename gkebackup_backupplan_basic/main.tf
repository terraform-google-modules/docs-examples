resource "google_gke_backup_backup_plan" "basic" {
  name = "basic-plan-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/basic-cluster-${local.name_suffix}"
  location = "us-east1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}
