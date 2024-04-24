resource "google_integrations_client" "client" {
  location = "northamerica-northeast2"
}

resource "google_integrations_auth_config" "username_and_password_example" {
    location = "northamerica-northeast2"
    display_name = "test-authconfig-username-and-password-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "USERNAME_AND_PASSWORD"
        username_and_password {
            username = "test-username"
            password = "test-password"
        }
    }
    depends_on = [google_integrations_client.client]
}
