resource "google_parameter_manager_regional_parameter" "regional-parameter-with-format" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  location = "us-central1"
  format = "JSON"
}
