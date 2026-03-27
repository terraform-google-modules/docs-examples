resource "google_model_armor_template" "template-template-metadata" {
  location    = "us-central1-${local.name_suffix}"
  template_id = "modelarmor3-${local.name_suffix}"

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "HARASSMENT-${local.name_suffix}"
        confidence_level = "MEDIUM_AND_ABOVE-${local.name_suffix}"
      }
    }
  }
  template_metadata {
    custom_llm_response_safety_error_message = "This is a custom error message for LLM response-${local.name_suffix}"
    log_sanitize_operations                  = false-${local.name_suffix}
    log_template_operations                  = true-${local.name_suffix}
    multi_language_detection {
      enable_multi_language_detection        = true-${local.name_suffix}
    }
    ignore_partial_invocation_failures       = false-${local.name_suffix}
    custom_prompt_safety_error_code          = 400-${local.name_suffix}
    custom_prompt_safety_error_message       = "This is a custom error message for prompt-${local.name_suffix}"
    custom_llm_response_safety_error_code    = 401-${local.name_suffix}
    enforcement_type                         = "INSPECT_ONLY-${local.name_suffix}"
  }
}
