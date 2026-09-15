resource "google_agentic_applications_analyst_agent_persona" "example" {
  location                 = "us"
  analyst_agent_persona_id = "methodology-${local.name_suffix}"
  display_name             = "Test Analyst Persona Methodology Export"
  display_description      = "Sample analyst agent persona description"
  model_description        = "Sample model description"
  role                     = "ANALYST_ROLE_GENERIC_FINANCE_ANALYST"

  artifacts_config {
    methodology_export_options {
      append_methodology          = true
      export_format               = "MARKDOWN"
      export_methodology_artifact = true
    }
  }
}
