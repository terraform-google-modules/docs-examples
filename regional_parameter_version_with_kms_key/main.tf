data "google_project" "project" {}

resource "google_parameter_manager_regional_parameter" "regional-parameter-basic" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  location = "us-central1"

  kms_key = "kms-key-${local.name_suffix}"
}

resource "google_parameter_manager_regional_parameter_version" "regional-parameter-version-with-kms-key" {
  parameter = google_parameter_manager_regional_parameter.regional-parameter-basic.id
  parameter_version_id = "regional_parameter_version-${local.name_suffix}"
  parameter_data = "regional-parameter-version-data"
}
