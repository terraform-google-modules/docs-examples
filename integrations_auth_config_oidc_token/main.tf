resource "google_integrations_client" "client" {
  location = "us-south1"
}

resource "google_service_account" "service_account" {
  account_id   = "sa-${local.name_suffix}"
  display_name = "Service Account"
}

resource "google_integrations_auth_config" "oidc_token_example" {
    location = "us-south1"
    display_name = "test-authconfig-oidc-token-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "OIDC_TOKEN"
        oidc_token {
            service_account_email = google_service_account.service_account.email
            audience = "https://us-south1-project.cloudfunctions.net/functionA 1234987819200.apps.googleusercontent.com"
        }
    }
    depends_on = [google_service_account.service_account, google_integrations_client.client]
}
