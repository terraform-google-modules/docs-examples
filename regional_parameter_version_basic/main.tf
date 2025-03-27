resource "google_parameter_manager_regional_parameter" "regional-parameter-basic" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  location = "us-central1"
}

resource "google_parameter_manager_regional_parameter_version" "regional-parameter-version-basic" {
  parameter = google_parameter_manager_regional_parameter.regional-parameter-basic.id
  parameter_version_id = "regional_parameter_version-${local.name_suffix}"
  parameter_data = "regional-parameter-version-data"
}
