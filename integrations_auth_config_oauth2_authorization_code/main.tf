resource "google_integrations_client" "client" {
  location = "asia-east1"
}

resource "google_integrations_auth_config" "oauth2_authotization_code_example" {
    location = "asia-east1"
    display_name = "test-authconfig-oauth2-authorization-code-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "OAUTH2_AUTHORIZATION_CODE"
        oauth2_authorization_code {
            client_id = "Kf7utRvgr95oGO5YMmhFOLo8"
            client_secret = "D-XXFDDMLrg2deDgczzHTBwC3p16wRK1rdKuuoFdWqO0wliJ"
            scope = "photo offline_access"
            auth_endpoint = "https://authorization-server.com/authorize"
            token_endpoint = "https://authorization-server.com/token"
        }
    }
    depends_on = [google_integrations_client.client]
}
