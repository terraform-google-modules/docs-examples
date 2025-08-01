resource "google_model_armor_template" "template-template-metadata" {
  location    = "<no value>"
  template_id = "<no value>"

  filter_config {
    rai_settings {
      rai_filters {
        filter_type      = "<no value>"
        confidence_level = "<no value>"
      }
    }
  }
  template_metadata {
    custom_llm_response_safety_error_message = "<no value>"
    log_sanitize_operations                  = <no value>
    log_template_operations                  = <no value>
    multi_language_detection {
      enable_multi_language_detection        = <no value>
    }
    ignore_partial_invocation_failures       = <no value>
    custom_prompt_safety_error_code          = <no value>
    custom_prompt_safety_error_message       = "<no value>"
    custom_llm_response_safety_error_code    = <no value>
    enforcement_type                         = "<no value>"
  }
}
