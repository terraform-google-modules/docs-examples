resource "google_model_armor_template" "template-filter-config" {
  location    = "<no value>"
  template_id = "<no value>"

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "<no value>"
        confidence_level = "<no value>"
      }
    }
    sdp_settings {
      basic_config {
          filter_enforcement = "<no value>"
      }
    }
    pi_and_jailbreak_filter_settings {
      filter_enforcement = "<no value>"
      confidence_level   = "<no value>"
    }
    malicious_uri_filter_settings {
      filter_enforcement = "<no value>"
    }
  }
  template_metadata {
    multi_language_detection {
    enable_multi_language_detection        = <no value>
    }
  }
}
