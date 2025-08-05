resource "google_parameter_manager_regional_parameter" "regional-parameter-basic" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  format = "JSON"
  location = "us-central1"
}

resource "google_parameter_manager_regional_parameter_version" "regional-parameter-version-with-json-format-with-file" {
  parameter = google_parameter_manager_regional_parameter.regional-parameter-basic.id
  parameter_version_id = "regional_parameter_version-${local.name_suffix}"
  parameter_data = file("regional-parameter-json-data.json-${local.name_suffix}")
}
