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

resource "google_ces_guardrail" "ces_guardrail_llm_policy" {
  guardrail_id = "guardrail-id-${local.name_suffix}"
  location     = google_ces_app.ces_app_for_guardrail.location
  app          = google_ces_app.ces_app_for_guardrail.app_id
  display_name = "my-guardrail-${local.name_suffix}"
  description  = "Guardrail description"
  action {
    generative_answer {
        prompt = "example_prompt"
    }
  }
  enabled = true
  llm_policy {
    max_conversation_messages = 10
    model_settings {
        model = "gemini-2.5-flash"
        temperature = 50
    }
    prompt = "example_prompt"
    policy_scope = "USER_QUERY"
    fail_open = true
    allow_short_utterance = true
  }
}
