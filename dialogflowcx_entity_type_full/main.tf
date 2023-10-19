resource "google_dialogflow_cx_agent" "agent" {
  display_name = "dialogflowcx-agent-${local.name_suffix}"
  location = "global"
  default_language_code = "en"
  supported_language_codes = ["fr","de","es"]
  time_zone = "America/New_York"
  description = "Example description."
  avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = true
  speech_to_text_settings {
    enable_speech_adaptation = true
  }
}


resource "google_dialogflow_cx_entity_type" "basic_entity_type" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "MyEntity"
  kind         = "KIND_MAP"
  entities {
    value = "value1"
    synonyms = ["synonym1","synonym2"]
  }
  entities {
    value = "value2"
    synonyms = ["synonym3","synonym4"]
  }
  enable_fuzzy_extraction = false
} 
