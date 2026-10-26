resource "google_model_armor_template" "template-filter-config" {
  location    = "us-central1-${local.name_suffix}"
  template_id = "modelarmor2-${local.name_suffix}"

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "HATE_SPEECH-${local.name_suffix}"
        confidence_level = "HIGH-${local.name_suffix}"
      }
    }
    sdp_settings {
      basic_config {
          filter_enforcement = "ENABLED-${local.name_suffix}"
      }
    }
    pi_and_jailbreak_filter_settings {
      filter_enforcement = "ENABLED-${local.name_suffix}"
      confidence_level   = "MEDIUM_AND_ABOVE-${local.name_suffix}"
    }
    malicious_uri_filter_settings {
      filter_enforcement = "ENABLED-${local.name_suffix}"
    }
    filter_rule_settings {
      rule_sets {
        filter_types = ["PROMPT_INJECTION_AND_JAILBREAK", "RESPONSIBLE_AI"]
        rules {
          exclusion_rule {
            matching_scope = "MATCHING_SCOPE_PARTIAL_MATCH"
            dictionary {
              word_list {
                words = ["allowphrase1", "allowphrase2"]
              }
            }
          }
        }
        rules {
          exclusion_rule {
            matching_scope = "MATCHING_SCOPE_FULL_MATCH"
            regex {
              pattern = "^safe_pattern_[0-9]+$"
            }
          }
        }
      }
    }
  }
  template_metadata {
    multi_language_detection {
    enable_multi_language_detection        = false-${local.name_suffix}
    }
  }
}
