resource "google_dialogflow_cx_agent" "agent" {
  display_name = "issue-12880-${local.name_suffix}"
  location = "us-central1"
  default_language_code = "en"
  supported_language_codes = ["fr","de","es"]
  time_zone = "Europe/London"
  description = "CX BOT Agent"
  enable_stackdriver_logging = true
  speech_to_text_settings {
    enable_speech_adaptation = true
  }
}


resource "google_dialogflow_cx_version" "version_1" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "1.0.0"
  description  = "version 1.0.0"
}
