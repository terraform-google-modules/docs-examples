resource "google_ces_app" "ces_app_for_guardrail" {
  app_id = "app-id-${local.name_suffix}"
  location = "us"
  description = "App used as parent for CES Toolset example"
  display_name = "my-app-${local.name_suffix}"

  language_settings {
    default_language_code    = "en-US"
    supported_language_codes = ["es-ES", "fr-FR"]
    enable_multilingual_support = true
    fallback_action          = "escalate"
  }
  time_zone_settings {
    time_zone = "America/Los_Angeles"
  }
}

resource "google_ces_guardrail" "ces_guardrail_transfer_agent_content_filter" {
  guardrail_id = "guardrail-id-${local.name_suffix}"
  location     = google_ces_app.ces_app_for_guardrail.location
  app          = google_ces_app.ces_app_for_guardrail.app_id
  display_name = "my-guardrail-${local.name_suffix}"
  description  = "Guardrail description"
  action {
    transfer_agent {
        agent = "projects/${google_ces_app.ces_app_for_guardrail.project}/locations/us/apps/${google_ces_app.ces_app_for_guardrail.app_id}/agents/fake-agent"
    }
  }
  enabled = true
  content_filter {
    banned_contents = ["example"]
    banned_contents_in_user_input = ["example"]
    banned_contents_in_agent_response = ["example"]
    match_type = "SIMPLE_STRING_MATCH"
    disregard_diacritics = true
  }
}
