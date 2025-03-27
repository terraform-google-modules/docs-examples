resource "google_parameter_manager_regional_parameter" "regional-parameter-with-labels" {
  parameter_id = "regional_parameter-${local.name_suffix}"
  location = "us-central1"

  labels = {
    key1 = "val1"
    key2 = "val2"
    key3 = "val3"
    key4 = "val4"
    key5 = "val5"
  }
}
