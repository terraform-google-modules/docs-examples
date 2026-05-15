resource "google_migration_center_group" "default" {
  location = "us-central1"
  group_id = "group-test-${local.name_suffix}"
}

resource "google_migration_center_preference_set" "default" {
  location          = "us-central1"
  preference_set_id = "pref-set-test-${local.name_suffix}"
}

resource "google_migration_center_report_config" "default" {
  location         = "us-central1"
  report_config_id = "report-config-test-${local.name_suffix}"
  description      = "Terraform integration test description"
  display_name     = "Terraform integration test display"
  group_preferenceset_assignments {
    group          = google_migration_center_group.default.id
    preference_set = google_migration_center_preference_set.default.id
  }
}
