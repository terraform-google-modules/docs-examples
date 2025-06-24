resource "google_dialogflow_cx_agent" "agent" {
  display_name = "dialogflowcx-agent-fucntion-${local.name_suffix}"
  location = "global"
  default_language_code = "en"
  time_zone = "America/New_York"
  description = "Example description."
}

resource "google_dialogflow_cx_tool" "function_tool" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "Example Function Tool"
  description  = "Example Description"
  function_spec {
    input_schema  = <<EOF
      {
        "type": "object",
        "properties": {
          "message_to_echo": {
            "type": "string",
            "description": "The message that should be echoed back."
          }
        },
        "required": [
          "message_to_echo"
        ]
      }
    EOF
    output_schema = <<EOF
      {
        "type": "object",
        "properties": {
          "echoed_message": {
            "type": "string",
            "description": "The message that is echoed back."
          }
        }
      }
    EOF
  }
}
