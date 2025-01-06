resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"

  github_config {
    github_app = "DEVELOPER_CONNECT"

    authorizer_credential {
      oauth_token_secret_version = "projects/devconnect-terraform-creds/secrets/tf-test-do-not-change-github-oauthtoken-e0b9e7/versions/1"
    }
  }
}
