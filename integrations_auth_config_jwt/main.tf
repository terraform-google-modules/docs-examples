resource "google_integrations_auth_config" "jwt_example" {
    location = "us-east4"
    display_name = "test-authconfig-jwt-${local.name_suffix}"
    description = "Test auth config created via terraform"
    decrypted_credential {
        credential_type = "JWT"
        jwt {
            jwt_header = "{\"alg\": \"HS256\", \"typ\": \"JWT\"}"
            jwt_payload = "{\"sub\": \"1234567890\", \"name\": \"John Doe\", \"iat\": 1516239022}"
            secret = "secret"
        }
    }
}
