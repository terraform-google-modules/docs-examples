data "google_project" "project" {}

resource "google_parameter_manager_parameter" "parameter-basic" {
  parameter_id = "parameter-${local.name_suffix}"
  kms_key = "kms-key-${local.name_suffix}"
}

resource "google_parameter_manager_parameter_version" "parameter-version-with-kms-key" {
  parameter = google_parameter_manager_parameter.parameter-basic.id
  parameter_version_id = "parameter_version-${local.name_suffix}"
  parameter_data = "app-parameter-version-data"
}
