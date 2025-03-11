resource "google_integrations_auth_config" "auth_token_example" {
    location = "us-east4"
    display_name = "test-authconfig-auth-token-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "AUTH_TOKEN"
        auth_token {
            type = "Basic"
            token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
        }
    }
}
