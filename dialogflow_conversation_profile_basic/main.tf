resource "google_dialogflow_agent" "basic_agent" {
  display_name = "example_agent"
  default_language_code = "en"
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
  stt_config {
    use_gemini_asr = true
    gemini_asr_config {
      model_id                    = "gemini-3-flash-lite-asr-preview"
      silence_duration_ms         = 1000
      prefix_padding_ms           = 500
      start_of_speech_sensitivity = "START_SENSITIVITY_LOW"
      end_of_speech_sensitivity   = "END_SENSITIVITY_LOW"
    }
  }
}
