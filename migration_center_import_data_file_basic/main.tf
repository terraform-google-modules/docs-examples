resource "google_migration_center_source" "default" {
  location  = "us-central1"
  source_id = "source-test-${local.name_suffix}"
  type      = "SOURCE_TYPE_CUSTOM"
}

resource "google_migration_center_import_job" "default" {
  location      = "us-central1"
  import_job_id = "import-job-test-${local.name_suffix}"
  asset_source  = google_migration_center_source.default.id
}

resource "google_migration_center_import_data_file" "default" {
  location            = "us-central1"
  import_job          = google_migration_center_import_job.default.import_job_id
  import_data_file_id = "import-data-file-test-${local.name_suffix}"
  display_name        = "Terraform integration test display"
  format              = "IMPORT_JOB_FORMAT_RVTOOLS_XLSX"
}
