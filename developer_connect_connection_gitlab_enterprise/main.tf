resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"

  gitlab_enterprise_config {
    host_uri = "https://gle-us-central1.gcb-test.com"
    
    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-enterprise-webhook/versions/latest"

    read_authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-enterprise-read-cred/versions/latest"
    }

    authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/gitlab-enterprise-auth-cred/versions/latest"
    }
  }
}
