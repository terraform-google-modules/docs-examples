resource "google_gemini_data_analytics_data_agent" "example" {
  location      = "global"
  data_agent_id = "data-agent-${local.name_suffix}"
  display_name  = "Example data agent"
  description   = "Example Gemini Data Analytics data agent."

  labels = {
    env = "test"
  }

  data_analytics_agent {
    staging_context {
      system_instruction = "Answer questions about the sample Shakespeare corpus."

      datasource_references {
        bq {
          table_references {
            project_id = "bigquery-public-data"
            dataset_id = "samples"
            table_id   = "shakespeare"
          }
        }
      }
    }
  }
}
