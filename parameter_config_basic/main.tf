resource "google_parameter_manager_parameter" "parameter-basic" {
  parameter_id = "parameter-${local.name_suffix}"
}
