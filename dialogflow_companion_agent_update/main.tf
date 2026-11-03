resource "google_dialogflow_companion_agent" "default" {
  location           = "global"
  companion_agent_id = "companion-agent-${local.name_suffix}"
  display_name       = "companion-agent-updated-${local.name_suffix}"
  description        = "Updated Companion Agent Description"

  skill_configs {
    skill_triggering_event = "AGENT_MESSAGE"
    guidance_skill_config {
      overarching_guidance = "Always provide helpful answers"
      guidance_instructions {
        display_name            = "follow-up"
        display_details         = "Follow-up instruction after agent reply"
        condition               = "Agent responds to customer"
        disable_suggested_reply = false
        trigger_event           = "AGENT_MESSAGE"
        actions {
          description = "Confirm next steps with customer"
        }
      }
    }
  }
}
