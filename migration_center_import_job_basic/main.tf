resource "google_migration_center_source" "default" {
  location  = "us-central1"
  source_id = "source-test-${local.name_suffix}"
  type      = "SOURCE_TYPE_CUSTOM"
}

resource "google_migration_center_import_job" "default" {
  location      = "us-central1"
  import_job_id = "import-job-test-${local.name_suffix}"
  asset_source  = google_migration_center_source.default.id
  display_name  = "Terraform integration test display"
  labels = {
    my_key     = "value"
    second_key = "second_value"
  }
}
