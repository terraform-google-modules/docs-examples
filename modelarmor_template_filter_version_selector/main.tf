resource "google_model_armor_template" "template-filter-version-selector" {
  location    = "us-central1-${local.name_suffix}"
  template_id = "modelarmor5-${local.name_suffix}"

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "HATE_SPEECH-${local.name_suffix}"
        confidence_level = "HIGH-${local.name_suffix}"
      }
    }
  }
  template_metadata {
    filter_version_selector {
      version = "v1-${local.name_suffix}"
    }
  }
}
