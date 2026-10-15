resource "google_gke_backup_backup_plan" "rpo_weekly_window" {
  name = "rpo-weekly-window-${local.name_suffix}"
  cluster = "projects/my-project-name/locations/us-east1/clusters/rpo-weekly-cluster-${local.name_suffix}"
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
          hours = 1
          minutes = 23
        }
        duration = "1800s"
        days_of_week {
          days_of_week = ["MONDAY", "THURSDAY"]
        }
      }
      exclusion_windows {
        start_time  {
          hours = 12
        }
        duration = "3600s"
        single_occurrence_date {
          year = 2024
          month = 3
          day = 17
        }
      }
      exclusion_windows {
        start_time  {
          hours = 8
          minutes = 40
        }
        duration = "600s"
        single_occurrence_date {
          year = 2024
          month = 3
          day = 18
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
