resource "google_monitoring_custom_service" "custom" {
  service_id = "custom-srv-${local.name_suffix}"
  display_name = "My Custom Service custom-srv-${local.name_suffix}"

  telemetry {
  	resource_name = "//product.googleapis.com/foo/foo/services/test-${local.name_suffix}"
  }

  user_labels = {
    my_key       = "my_value"
    my_other_key = "my_other_value"
  }
}
