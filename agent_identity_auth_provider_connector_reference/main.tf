resource "google_agent_identity_auth_provider" "default" {
  location         = "us-central1"
  auth_provider_id = "connref-provider-${local.name_suffix}"
  description      = "Connector reference auth provider"

  auth_provider_type_params {
    connector_reference_auth_provider {
      connector = "salesforce-connector-prod"
      authorization_details = jsonencode([
        {
          type     = "oauth_authorization"
          resource = "https://example.com/api"
        }
      ])
    }
  }
}
