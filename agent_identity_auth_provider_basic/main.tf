resource "google_agent_identity_auth_provider" "default" {
    location         = "us-central1"
    auth_provider_id = "example-provider-${local.name_suffix}"
  
    auth_provider_type_params {
      api_key {
        api_key = "test-api-key-value"
      }
    }
  }
