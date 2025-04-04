resource "google_integrations_auth_config" "username_and_password_example" {
    location = "us-east4"
    display_name = "test-authconfig-username-and-password-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "USERNAME_AND_PASSWORD"
        username_and_password {
            username = "test-username"
            password = "test-password"
        }
    }
}
