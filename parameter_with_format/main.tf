resource "google_parameter_manager_parameter" "parameter-with-format" {
  parameter_id = "parameter-${local.name_suffix}"
  format = "JSON"
}
