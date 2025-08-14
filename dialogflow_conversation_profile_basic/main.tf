resource "google_dialogflow_agent" "basic_agent" {
  display_name = "example_agent"
  default_language_code = "en-us"
  time_zone = "America/New_York"
}
resource "google_dialogflow_conversation_profile" "basic_profile" {
  display_name = "dialogflow-profile-${local.name_suffix}"
  location = "global"
  automated_agent_config {
    agent = "projects/${google_dialogflow_agent.basic_agent.id}/locations/global/agent/environments/draft"
  }
  human_agent_assistant_config {
    message_analysis_config {
      enable_entity_extraction  = true
      enable_sentiment_analysis = true
    }
  }
}
