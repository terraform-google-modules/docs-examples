resource "google_gke_backup_backup_plan" "full" {
  name = "full-plan-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/full-cluster-${local.name_suffix}"
  location = "us-east1"
  retention_policy {
    backup_delete_lock_days = 30
    backup_retain_days = 180
  }
  backup_schedule {
    cron_schedule = "0 9 * * 1"
  }
  backup_config {
    include_volume_data = true
    include_secrets = true
    selected_applications {
      namespaced_names {
        name = "app1"
        namespace = "ns1"
      }
      namespaced_names {
        name = "app2"
        namespace = "ns2"
      }
    }
  }
}
