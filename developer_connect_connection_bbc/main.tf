resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"

  bitbucket_cloud_config {
    workspace = "proctor-test"
    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/bbc-webhook/versions/latest"

    read_authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbc-read-token/versions/latest"
    }

    authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbc-auth-token/versions/latest"
    }
  }
}
