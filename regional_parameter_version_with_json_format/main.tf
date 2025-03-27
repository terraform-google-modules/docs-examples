resource "google_parameter_manager_regional_parameter" "regional-parameter-basic" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  format = "JSON"
  location = "us-central1"
}

resource "google_parameter_manager_regional_parameter_version" "regional-parameter-version-with-json-format" {
  parameter = google_parameter_manager_regional_parameter.regional-parameter-basic.id
  parameter_version_id = "regional_parameter_version-${local.name_suffix}"
  parameter_data = jsonencode({
    "key1": "val1",
    "key2": "val2"
  })
}
