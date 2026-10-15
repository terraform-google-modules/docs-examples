resource "google_gke_backup_backup_plan" "basic" {
  name = "all-groupkinds-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/all-groupkinds-cluster-${local.name_suffix}"
  location = "us-east1"
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}

resource "google_gke_backup_restore_plan" "all_cluster_resources" {
  name = "all-groupkinds-${local.name_suffix}-rp"
  location = "us-east1"
  backup_plan = google_gke_backup_backup_plan.basic.id
  cluster = "projects/my-project-name/locations/us-east1/clusters/all-groupkinds-cluster-${local.name_suffix}"
  restore_config {
    no_namespaces = true
    namespaced_resource_restore_mode = "FAIL_ON_CONFLICT"
    cluster_resource_restore_scope {
      all_group_kinds = true
    }
    cluster_resource_conflict_policy = "USE_EXISTING_VERSION"
  }
}
