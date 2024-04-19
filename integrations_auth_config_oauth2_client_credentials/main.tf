resource "google_integrations_client" "client" {
  location = "southamerica-east1"
  provision_gmek = true
}

resource "google_integrations_auth_config" "oauth2_client_credentials_example" {
    location = "southamerica-east1"
    display_name = "test-authconfig-oauth2-client-credentials-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "OAUTH2_CLIENT_CREDENTIALS"
        oauth2_client_credentials {
            client_id = "demo-backend-client"
            client_secret = "MJlO3binatD9jk1"
            scope = "read"
            token_endpoint = "https://login-demo.curity.io/oauth/v2/oauth-token"
            request_type = "ENCODED_HEADER"
            token_params {
                entries {
                    key {
                        literal_value {
                            string_value = "string-key"
                        }
                    }
                    value {
                        literal_value {
                            string_value = "string-value"
                        }
                    }
                }
            }
        }
    }
    depends_on = [google_integrations_client.client]
}
