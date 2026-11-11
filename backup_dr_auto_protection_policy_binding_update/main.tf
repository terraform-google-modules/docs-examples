data "google_project" "project" {
}

resource "google_backup_dr_backup_vault" "my_backup_vault" {
  location                                   = "us-central1"
  backup_vault_id                            = "bv-app-binding-${local.name_suffix}"
  backup_minimum_enforced_retention_duration = "100000s"
}

resource "google_backup_dr_backup_plan" "my_backup_plan" {
  location       = "us-central1"
  backup_plan_id = "bp-app-binding-${local.name_suffix}"
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

resource "google_backup_dr_auto_protection_policy" "my_policy" {
  location                  = "us-central1"
  auto_protection_policy_id = "app-binding-${local.name_suffix}"

  criteria {
    matching_conditions {
      label_condition {
        key    = "backup-policy"
        values = ["gold-${local.name_suffix}"]
      }
    }
  }

  backup_plan_details {
    resource_type = "compute.googleapis.com/Instance"
    backup_plan   = google_backup_dr_backup_plan.my_backup_plan.name
  }
}

resource "google_backup_dr_auto_protection_policy_binding" "my-binding" {
  location                          = "us-central1"
  auto_protection_policy_id         = google_backup_dr_auto_protection_policy.my_policy.auto_protection_policy_id
  auto_protection_policy_binding_id = "my-project-binding-${local.name_suffix}"
  scope                             = "projects/${data.google_project.project.project_id}"
  wait_for_delete                   = true
}
