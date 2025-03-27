resource "google_parameter_manager_regional_parameter" "regional-parameter-basic" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  location = "us-central1"
}
