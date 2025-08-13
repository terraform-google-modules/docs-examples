resource "google_dialogflow_cx_agent" "agent" {
  display_name          = "dialogflowcx-agent-basic-${local.name_suffix}"
  location              = "global"
  default_language_code = "en"
  time_zone             = "America/New_York"
  description           = "Example description."
}

resource "google_dialogflow_cx_playbook" "my-playbook" {
  parent        = google_dialogflow_cx_agent.agent.id
  display_name  = "Example Display Name"
  goal          = "Example Goal"
  playbook_type = "ROUTINE"
  instruction {
    steps {
      text = "step 1"
      steps = jsonencode([
        {
          "text": "step 1 1"
        },
        {
          "text": "step 1 2",
          "steps": [
            {
              "text": "step 1 2 1"
            },
            {
              "text": "step 1 2 2"
            }
          ]
        },
        {
          "text": "step 1 3"
        }
      ])
    }
    steps {
      text = "step 2"
    }
    steps {
      text = "step 3"
    }
  }
}
