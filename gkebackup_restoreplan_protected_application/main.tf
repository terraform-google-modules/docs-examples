resource "google_gke_backup_backup_plan" "basic" {
  name = "rollback-app-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/rollback-app-cluster-${local.name_suffix}"
  location = "us-east1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}

resource "google_gke_backup_restore_plan" "rollback_app" {
  name = "rollback-app-${local.name_suffix}-rp"
  location = "us-east1"
  backup_plan = google_gke_backup_backup_plan.basic.id
  cluster = "projects/my-project-name/locations/us-east1/clusters/rollback-app-cluster-${local.name_suffix}"
  restore_config {
    selected_applications {
      namespaced_names {
        name = "my-app"
        namespace = "my-ns"
      }
    }
    namespaced_resource_restore_mode = "DELETE_AND_RESTORE"
    volume_data_restore_policy = "REUSE_VOLUME_HANDLE_FROM_BACKUP"
    cluster_resource_restore_scope {
      no_group_kinds = true
    }
  }
}
