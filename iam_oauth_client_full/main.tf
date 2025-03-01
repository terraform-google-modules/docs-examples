resource "google_iam_oauth_client" "example" {
  oauth_client_id = "example-client-id-${local.name_suffix}"
  display_name              = "Display Name of OAuth client"
  description               = "A sample OAuth client"
  location                  = "global"
  disabled                  = false
  allowed_grant_types       = ["AUTHORIZATION_CODE_GRANT"]
  allowed_redirect_uris     = ["https://www.example.com"]
  allowed_scopes            = ["https://www.googleapis.com/auth/cloud-platform"]
  client_type               = "CONFIDENTIAL_CLIENT"
}
