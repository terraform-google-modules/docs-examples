resource "google_filestore_instance" "my_filestore_instance" {
  name = "test-instance-bpa-${local.name_suffix}"
  location = "us-central1"
  tier = "ENTERPRISE"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}

resource "google_backup_dr_backup_vault" "my_backup_vault" {
  location = "us-central1"
  backup_vault_id = "bv-bpa-filestore-${local.name_suffix}"
  backup_minimum_enforced_retention_duration = "100000s"
  force_delete = true
}

resource "google_backup_dr_backup_plan" "my_backup_plan" {
  location = "us-central1"
  backup_plan_id = "bp-bpa-filestore-${local.name_suffix}"
  resource_type = "file.googleapis.com/Instance"
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

resource "google_backup_dr_backup_plan_association" "my-backup-plan-association-filestore" {
  location = "us-central1"
  resource_type = "file.googleapis.com/Instance"
  backup_plan_association_id = "my-bpa-filestore-${local.name_suffix}"
  resource = google_filestore_instance.my_filestore_instance.id
  backup_plan = google_backup_dr_backup_plan.my_backup_plan.name
}
