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

resource "google_ces_guardrail" "ces_guardrail_code_callback" {
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
  code_callback {
    before_agent_callback {
        description = "Example callback"
        disabled    = true
        python_code = "def callback(context):\n    return {'override': False}"
    }
    after_agent_callback {
        description = "Example callback"
        disabled    = true
        python_code = "def callback(context):\n    return {'override': False}"
    }
    before_model_callback {
        description = "Example callback"
        disabled    = true
        python_code = "def callback(context):\n    return {'override': False}"
    }
    after_model_callback {
        description = "Example callback"
        disabled    = true
        python_code = "def callback(context):\n    return {'override': False}"
    }
  }
}
