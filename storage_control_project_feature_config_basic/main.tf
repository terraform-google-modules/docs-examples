resource "google_storage_control_project_feature_config" "example" {
  feature_config_id = "feature-config-${local.name_suffix}"

  auto_annotate_config {
    models {
      name = "object-detector"
    }
    processing_location = "us"
  }
}
