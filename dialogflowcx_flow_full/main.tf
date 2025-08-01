resource "google_dialogflow_cx_agent" "agent" {
  display_name               = "dialogflowcx-agent-${local.name_suffix}"
  location                   = "global"
  default_language_code      = "en"
  supported_language_codes   = ["fr", "de", "es"]
  time_zone                  = "America/New_York"
  description                = "Example description."
  avatar_uri                 = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = true
  speech_to_text_settings {
    enable_speech_adaptation = true
  }
}

resource "google_storage_bucket" "bucket" {
  name                        = "dialogflowcx-bucket-${local.name_suffix}"
  location                    = "US"
  uniform_bucket_level_access = true
}


resource "google_dialogflow_cx_flow" "basic_flow" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "MyFlow"
  description  = "Test Flow"

  nlu_settings {
    classification_threshold = 0.3
    model_type               = "MODEL_TYPE_STANDARD"
  }

  event_handlers {
    event = "custom-event"
    trigger_fulfillment {
      return_partial_responses = false
      messages {
        text {
          text = ["I didn't get that. Can you say it again?"]
        }
      }
    }
  }

  event_handlers {
    event = "sys.no-match-default"
    trigger_fulfillment {
      return_partial_responses = false
      messages {
        text {
          text = ["Sorry, could you say that again?"]
        }
      }
    }
  }

  event_handlers {
    event = "sys.no-input-default"
    trigger_fulfillment {
      return_partial_responses = false
      messages {
        text {
          text = ["One more time?"]
        }
      }
    }
  }

  event_handlers {
    event = "another-event"
    trigger_fulfillment {
      return_partial_responses = true
      messages {
        channel = "some-channel"
        text {
          text = ["Some text"]
        }
      }
      messages {
        payload = <<EOF
          {"some-key": "some-value", "other-key": ["other-value"]}
        EOF
      }
      messages {
        conversation_success {
          metadata = <<EOF
            {"some-metadata-key": "some-value", "other-metadata-key": 1234}
          EOF
        }
      }
      messages {
        output_audio_text {
          text = "some output text"
        }
      }
      messages {
        output_audio_text {
          ssml = <<EOF
            <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
          EOF
        }
      }
      messages {
        live_agent_handoff {
          metadata = <<EOF
            {"some-metadata-key": "some-value", "other-metadata-key": 1234}
          EOF
        }
      }
      messages {
        play_audio {
          audio_uri = "http://example.com/some-audio-file.mp3"
        }
      }
      messages {
        telephony_transfer_call {
          phone_number = "1-234-567-8901"
        }
      }

      set_parameter_actions {
        parameter = "some-param"
        value     = "123.45"
      }
      set_parameter_actions {
        parameter = "another-param"
        value     = jsonencode("abc")
      }
      set_parameter_actions {
        parameter = "other-param"
        value     = jsonencode(["foo"])
      }

      conditional_cases {
        cases = jsonencode([
          {
            condition = "$sys.func.RAND() < 0.5",
            caseContent = [
              {
                message = { text = { text = ["First case"] } }
              },
              {
                additionalCases = {
                  cases = [
                    {
                      condition = "$sys.func.RAND() < 0.2"
                      caseContent = [
                        {
                          message = { text = { text = ["Nested case"] } }
                        }
                      ]
                    }
                  ]
                }
              }
            ]
          },
          {
            caseContent = [
              {
                message = { text = { text = ["Final case"] } }
              }
            ]
          },
        ])
      }

      enable_generative_fallback = true
    }
  }

  transition_routes {
    condition = "true"
    trigger_fulfillment {
      return_partial_responses = true
      messages {
        channel = "some-channel"
        text {
          text = ["Some text"]
        }
      }
      messages {
        payload = <<EOF
          {"some-key": "some-value", "other-key": ["other-value"]}
        EOF
      }
      messages {
        conversation_success {
          metadata = <<EOF
            {"some-metadata-key": "some-value", "other-metadata-key": 1234}
          EOF
        }
      }
      messages {
        output_audio_text {
          text = "some output text"
        }
      }
      messages {
        output_audio_text {
          ssml = <<EOF
            <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
          EOF
        }
      }
      messages {
        live_agent_handoff {
          metadata = <<EOF
            {"some-metadata-key": "some-value", "other-metadata-key": 1234}
          EOF
        }
      }
      messages {
        play_audio {
          audio_uri = "http://example.com/some-audio-file.mp3"
        }
      }
      messages {
        telephony_transfer_call {
          phone_number = "1-234-567-8901"
        }
      }

      set_parameter_actions {
        parameter = "some-param"
        value     = "123.45"
      }
      set_parameter_actions {
        parameter = "another-param"
        value     = jsonencode("abc")
      }
      set_parameter_actions {
        parameter = "other-param"
        value     = jsonencode(["foo"])
      }

      conditional_cases {
        cases = jsonencode([
          {
            condition = "$sys.func.RAND() < 0.5",
            caseContent = [
              {
                message = { text = { text = ["First case"] } }
              },
              {
                additionalCases = {
                  cases = [
                    {
                      condition = "$sys.func.RAND() < 0.2"
                      caseContent = [
                        {
                          message = { text = { text = ["Nested case"] } }
                        }
                      ]
                    }
                  ]
                }
              }
            ]
          },
          {
            caseContent = [
              {
                message = { text = { text = ["Final case"] } }
              }
            ]
          },
        ])
      }
    }
    target_flow = google_dialogflow_cx_agent.agent.start_flow
  }

  advanced_settings {
    audio_export_gcs_destination {
      uri = "${google_storage_bucket.bucket.url}/prefix-"
    }
    speech_settings {
      endpointer_sensitivity        = 30
      no_speech_timeout             = "3.500s"
      use_timeout_based_endpointing = true
      models = {
        name : "wrench"
        mass : "1.3kg"
        count : "3"
      }
    }
    dtmf_settings {
      enabled      = true
      max_digits   = 1
      finish_digit = "#"
    }
    logging_settings {
      enable_stackdriver_logging     = true
      enable_interaction_logging     = true
      enable_consent_based_redaction = true
    }
  }

  knowledge_connector_settings {
    enabled = true
    trigger_fulfillment {
      messages {
        channel = "some-channel"
        text {
          text = ["information completed, navigating to page 2"]
        }
      }
      messages {
        payload = <<EOF
          {"some-key": "some-value", "other-key": ["other-value"]}
        EOF
      }
      messages {
        conversation_success {
          metadata = <<EOF
            {"some-metadata-key": "some-value", "other-metadata-key": 1234}
          EOF
        }
      }
      messages {
        output_audio_text {
          text = "some output text"
        }
      }
      messages {
        output_audio_text {
          ssml = <<EOF
            <speak>Some example <say-as interpret-as="characters">SSML XML</say-as></speak>
          EOF
        }
      }
      messages {
        live_agent_handoff {
          metadata = <<EOF
            {"some-metadata-key": "some-value", "other-metadata-key": 1234}
          EOF
        }
      }
      messages {
        play_audio {
          audio_uri = "http://example.com/some-audio-file.mp3"
        }
      }
      messages {
        telephony_transfer_call {
          phone_number = "1-234-567-8902"
        }
      }
      webhook = google_dialogflow_cx_webhook.my_webhook.id
      return_partial_responses = true
      tag = "some-tag"
      set_parameter_actions {
        parameter = "some-param"
        value     = "123.45"
      }
      conditional_cases {
        cases = jsonencode([
          {
            condition = "$sys.func.RAND() < 0.5",
            caseContent = [
              {
                message = { text = { text = ["First case"] } }
              }
            ]
          },
          {
            caseContent = [
              {
                message = { text = { text = ["Final case"] } }
              }
            ]
          },
        ])
      }
      advanced_settings {
        speech_settings {
          endpointer_sensitivity        = 30
          no_speech_timeout             = "3.500s"
          use_timeout_based_endpointing = true
          models = {
            name : "wrench"
            mass : "1.3kg"
            count : "3"
          }
        }
        dtmf_settings {
          enabled      = true
          max_digits   = 1
          finish_digit = "#"
          interdigit_timeout_duration = "3.500s"
          endpointing_timeout_duration = "3.500s"
        }
        logging_settings {
          enable_stackdriver_logging     = true
          enable_interaction_logging     = true
          enable_consent_based_redaction = true
        }
      }
      enable_generative_fallback = true
    }
    data_store_connections {
      data_store_type = "UNSTRUCTURED"
      data_store = "projects/${data.google_project.project.number}/locations/${google_dialogflow_cx_agent.agent.location}/collections/default_collection/dataStores/${google_discovery_engine_data_store.my_datastore.data_store_id}"
      document_processing_mode = "DOCUMENTS"
    }
    target_flow = google_dialogflow_cx_agent.agent.start_flow
  }
}

resource "google_discovery_engine_data_store" "my_datastore" {
  location          = "global"
  data_store_id     = "datastore-flow-full-${local.name_suffix}"
  display_name      = "datastore-flow-full"
  industry_vertical = "GENERIC"
  content_config    = "NO_CONTENT"
  solution_types    = ["SOLUTION_TYPE_CHAT"]
}

resource "google_dialogflow_cx_webhook" "my_webhook" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "MyWebhook"
  generic_web_service {
    uri = "https://example.com"
  }
}

data "google_project" "project" {
}
