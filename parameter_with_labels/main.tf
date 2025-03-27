resource "google_parameter_manager_parameter" "parameter-with-labels" {
  parameter_id = "parameter-${local.name_suffix}"

  labels = {
    key1 = "val1"
    key2 = "val2"
    key3 = "val3"
    key4 = "val4"
    key5 = "val5"
  }
}
