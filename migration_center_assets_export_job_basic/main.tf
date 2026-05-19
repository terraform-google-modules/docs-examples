resource "google_migration_center_assets_export_job" "default" {
  location             = "us-central1"
  assets_export_job_id = "assets-export-job-test-${local.name_suffix}"
  performance_data {
    max_days = 30
  }
  show_hidden = true
  signed_uri_destination {
    file_format = "CSV"
  }
  labels = {
    key = "value"
  }
}
