resource "google_agentic_applications_analyst_agent_persona" "example" {
  location                 = "us"
  analyst_agent_persona_id = "methodology-${local.name_suffix}"
  display_name             = "Test Analyst Persona Methodology Export Updated"
  display_description      = "Updated analyst agent persona description"
  model_description        = "Updated model description"
  role                     = "ANALYST_ROLE_GENERIC_FINANCE_ANALYST"

  artifacts_config {
    methodology_export_options {
      append_methodology          = false
      export_format               = "HTML"
      export_methodology_artifact = false
    }
  }
}
