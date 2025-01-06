resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"

  gitlab_config {
    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-webhook/versions/latest"
    
    read_authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-read-cred/versions/latest"
    }
    
    authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-auth-cred/versions/latest"
    }
  }
}
