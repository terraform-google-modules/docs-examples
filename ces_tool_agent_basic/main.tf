resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {   
        time_zone = "America/Los_Angeles"
    }
}

resource "google_ces_agent" "target_agent" {
  agent_id     = "target-agent"
  location     = "us"
  app          = google_ces_app.my-app.app_id
  display_name = "Target Agent"
  instruction  = "Target agent instruction"
  llm_agent {}
}

resource "google_ces_tool" "ces_tool_agent_basic" {
    location       = "us"
    app            = google_ces_app.my-app.name
    tool_id        = "ces_tool_basic5-${local.name_suffix}"
    execution_type = "SYNCHRONOUS"
    agent_tool {
        name        = "ces_tool_agent_basic-${local.name_suffix}"
        description = "example-description"
        agent       = "projects/${google_ces_app.my-app.project}/locations/us/apps/${google_ces_app.my-app.app_id}/agents/${google_ces_agent.target_agent.agent_id}"
    }
}
