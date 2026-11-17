resource "google_backup_dr_backup_vault" "my_backup_vault" {
  location = "us-central1"
  backup_vault_id = "backup-vault-netapp-test-${local.name_suffix}"
  backup_minimum_enforced_retention_duration = "100000s"
}

resource "google_backup_dr_backup_plan" "my-netapp-backup-plan-1" {
  location = "us-central1"
  backup_plan_id = "backup-plan-netapp-test-${local.name_suffix}"
  resource_type = "netapp.googleapis.com/Volume"
  backup_vault = google_backup_dr_backup_vault.my_backup_vault.id

  backup_rules {
    rule_id = "rule-1"
    backup_retention_days = 5

    standard_schedule {
      recurrence_type = "HOURLY"
      hourly_frequency = 6
      time_zone = "UTC"

      backup_window {
        start_hour_of_day = 0
        end_hour_of_day = 6
      }
    }
  }
}
