resource "google_cloudbuildv2_connection" "my-connection" {
  location = "us-central1"
  name = "tf-test-connection-${local.name_suffix}"

  github_config {
    app_installation_id = 0

    authorizer_credential {
      oauth_token_secret_version = "projects/gcb-terraform-creds/secrets/github-pat/versions/1"
    }
  }
}
