data "google_project" "project" {}

resource "google_parameter_manager_parameter" "parameter-with-kms-key" {
  parameter_id = "parameter-${local.name_suffix}"
  kms_key = "kms-key-${local.name_suffix}"
}
