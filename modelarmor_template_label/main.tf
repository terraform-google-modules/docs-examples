resource "google_model_armor_template" "template-label-advanced-config" {
  location    = "us-central1-${local.name_suffix}"
  template_id = "modelarmor4-${local.name_suffix}"

  labels = {
    "test-label" = "template-test-label-${local.name_suffix}"
  }

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "DANGEROUS-${local.name_suffix}"
        confidence_level = "MEDIUM_AND_ABOVE-${local.name_suffix}"
      }
    }
    sdp_settings {
      advanced_config {
        inspect_template     = "projects/llm-firewall-demo/locations/us-central1/inspectTemplates/t3-${local.name_suffix}"
        deidentify_template  = "projects/llm-firewall-demo/locations/us-central1/deidentifyTemplates/t2-${local.name_suffix}"
      }
    }
  }
  template_metadata {
    multi_language_detection {
      enable_multi_language_detection = false-${local.name_suffix}
    }
  }
}
