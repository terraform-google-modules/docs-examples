resource "google_agentic_applications_analyst_agent_persona" "example" {
  location                 = "us"
  analyst_agent_persona_id = "basic-${local.name_suffix}"
  display_name             = "Test Analyst Persona"
  display_description      = "Sample analyst agent persona description"
  customer_context         = ["Sample customer context for testing", "Initial additional context"]
  model_description        = "Sample model description"
  role                     = "ANALYST_ROLE_GENERIC_FINANCE_ANALYST"

  artifact_examples {
    resource {
      display_label     = "sample_raw_file"
      model_description = "Sample artifact resource model description"
      use_rag           = false
      raw_file_resource {
        file_title   = "financial_summary.txt"
        file_content = "UTEgUmV2ZW51ZTogMTAwTQ=="
        mime_type    = "text/plain"
      }
    }
  }

  skills {
    skill_id    = "finance_analysis_skill"
    description = "Skill for finance analysis"
    content     = "# Finance Analysis\nAnalyze financial data."
  }
}
