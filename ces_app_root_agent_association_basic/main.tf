resource "google_ces_app" "app" {
  location     = "eu"
  app_id       = "app-id-${local.name_suffix}"
  display_name = "Example App app-id-${local.name_suffix}"

  language_settings {
    default_language_code    = "en-US"
    supported_language_codes = ["es-ES"]
    fallback_action          = "escalate"
  }

  time_zone_settings {
    time_zone = "America/Los_Angeles"
  }

  lifecycle {
    ignore_changes = [root_agent]
  }
}

resource "google_ces_agent" "agent" {
  location     = google_ces_app.app.location
  app          = google_ces_app.app.app_id
  agent_id     = "agent-id-${local.name_suffix}"
  display_name = "Example Agent"

  instruction = "You are a helpful assistant."
  llm_agent {}
}

resource "google_ces_app_root_agent_association" "association" {
  location = google_ces_app.app.location
  app_id   = google_ces_app.app.app_id
  agent_id = google_ces_agent.agent.agent_id
}
