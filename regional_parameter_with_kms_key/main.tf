data "google_project" "project" {}

resource "google_parameter_manager_regional_parameter" "regional-parameter-with-kms-key" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  location = "us-central1"

  kms_key = "kms-key-${local.name_suffix}"
}
