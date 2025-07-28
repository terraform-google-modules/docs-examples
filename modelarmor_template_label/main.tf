resource "google_model_armor_template" "template-label-advanced-config" {
  location    = "<no value>"
  template_id = "<no value>"

  labels = {
    "test-label" = "<no value>"
  }

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "<no value>"
        confidence_level = "<no value>"
      }
    }
    sdp_settings {
      advanced_config {
        inspect_template     = "<no value>"
        deidentify_template  = "<no value>"
      }
    }
  }
  template_metadata {
    multi_language_detection {
      enable_multi_language_detection = <no value>
    }
  }
}
