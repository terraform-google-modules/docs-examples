resource "google_gke_backup_backup_plan" "rpo_daily_window" {
  name = "rpo-daily-window-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/rpo-daily-cluster-${local.name_suffix}"
  location = "us-east1"
  retention_policy {
    backup_delete_lock_days = 30
    backup_retain_days = 180
  }
  backup_schedule {
    paused = true
    rpo_config {
      target_rpo_minutes=1440
      exclusion_windows {
        start_time  {
          hours = 12
        }
        duration = "7200s"
        daily = true
      }
      exclusion_windows {
        start_time  {
          hours = 8
          minutes = 40
          seconds = 1
          nanos = 100
        }
        duration = "3600s"
        single_occurrence_date {
          year = 2024
          month = 3
          day = 16
        }
      }
    }
  }
  backup_config {
    include_volume_data = true
    include_secrets = true
    all_namespaces = true
  }
}
