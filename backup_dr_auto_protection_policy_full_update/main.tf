resource "google_backup_dr_backup_vault" "my_backup_vault" {
  location                                   = "us-central1"
  backup_vault_id                            = "bv-app-update-${local.name_suffix}"
  backup_minimum_enforced_retention_duration = "100000s"
}

resource "google_backup_dr_backup_plan" "instance_backup_plan" {
  location       = "us-central1"
  backup_plan_id = "bp-app-update-vm-${local.name_suffix}"
  resource_type  = "compute.googleapis.com/Instance"
  backup_vault   = google_backup_dr_backup_vault.my_backup_vault.id

  backup_rules {
    rule_id               = "rule-1"
    backup_retention_days = 5

    standard_schedule {
      recurrence_type  = "HOURLY"
      hourly_frequency = 6
      time_zone        = "UTC"

      backup_window {
        start_hour_of_day = 0
        end_hour_of_day   = 24
      }
    }
  }
}

resource "google_backup_dr_backup_plan" "disk_backup_plan" {
  location       = "us-central1"
  backup_plan_id = "bp-app-update-disk-${local.name_suffix}"
  resource_type  = "compute.googleapis.com/Disk"
  backup_vault   = google_backup_dr_backup_vault.my_backup_vault.id

  backup_rules {
    rule_id               = "rule-1"
    backup_retention_days = 5

    standard_schedule {
      recurrence_type  = "HOURLY"
      hourly_frequency = 6
      time_zone        = "UTC"

      backup_window {
        start_hour_of_day = 0
        end_hour_of_day   = 24
      }
    }
  }
}

resource "google_backup_dr_auto_protection_policy" "my-auto-protection-policy" {
  location                  = "us-central1"
  auto_protection_policy_id = "app-update-${local.name_suffix}"
  description               = "Protects staging disks."

  criteria {
    matching_conditions {
      label_condition {
        key    = "environment"
        values = ["staging"]
      }
    }
  }

  backup_plan_details {
    resource_type = "compute.googleapis.com/Disk"
    backup_plan   = google_backup_dr_backup_plan.disk_backup_plan.name
  }
}
