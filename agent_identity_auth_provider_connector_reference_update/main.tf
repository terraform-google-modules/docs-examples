resource "google_agent_identity_auth_provider" "default" {
  location         = "us-central1"
  auth_provider_id = "connref-provider-${local.name_suffix}"
  description      = "Updated connector reference auth provider"

  auth_provider_type_params {
    connector_reference_auth_provider {
      connector = "jira-connector-prod"
      authorization_details = jsonencode([
        {
          type     = "oauth_authorization"
          resource = "https://example.com/api/v2"
          actions  = ["read", "write"]
        }
      ])
    }
  }
}
