resource "google_storage_bucket" "bucket" {
  name                        = "dialogflowcx-bucket-${local.name_suffix}"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_dialogflow_cx_agent" "full_agent" {
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
  git_integration_settings {
    github_settings {
      display_name = "Github Repo"
      repository_uri = "https://api.github.com/repos/githubtraining/hellogitworld"
      tracking_branch = "main"
      access_token = "secret-token"
      branches = ["main"]
    }
  }
  text_to_speech_settings {
    synthesize_speech_configs = jsonencode({
      en = {
        voice = {
          name = "en-US-Neural2-A"
        }
      }
      fr = {
        voice = {
          name = "fr-CA-Neural2-A",
        }
      }
    })
  }
  gen_app_builder_settings {
    engine = "projects/-/locations/-/collections/-/engines/-"
  }
}
