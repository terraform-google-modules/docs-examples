resource "google_iam_oauth_client" "oauth_client" {
  oauth_client_id           = "example-client-id-${local.name_suffix}"
  location                  = "global"
  allowed_grant_types       = ["AUTHORIZATION_CODE_GRANT"]
  allowed_redirect_uris     = ["https://www.example.com"]
  allowed_scopes            = ["https://www.googleapis.com/auth/cloud-platform"]
  client_type               = "CONFIDENTIAL_CLIENT"
}

resource "google_iam_oauth_client_credential" "example" {
  oauthclient                   = google_iam_oauth_client.oauth_client.oauth_client_id
  location                      = google_iam_oauth_client.oauth_client.location
  oauth_client_credential_id    = "cred-id-${local.name_suffix}"
  disabled                      = true
  display_name                  = "Display Name of credential"
}
