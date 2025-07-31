resource "google_parameter_manager_parameter" "parameter-basic" {
  parameter_id = "parameter-${local.name_suffix}"
  format = "JSON"
}

resource "google_parameter_manager_parameter_version" "parameter-version-with-json-format-with-file" {
  parameter = google_parameter_manager_parameter.parameter-basic.id
  parameter_version_id = "parameter_version-${local.name_suffix}"
  parameter_data = file("parameter-json-data.json-${local.name_suffix}") 
}
