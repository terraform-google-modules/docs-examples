resource "google_parameter_manager_parameter" "parameter-basic" {
  parameter_id = "parameter-${local.name_suffix}"
  format = "YAML"
}

resource "google_parameter_manager_parameter_version" "parameter-version-with-yaml-format" {
  parameter = google_parameter_manager_parameter.parameter-basic.id
  parameter_version_id = "parameter_version-${local.name_suffix}"
  parameter_data = yamlencode({
    "key1": "val1",
    "key2": "val2"
  })
}
