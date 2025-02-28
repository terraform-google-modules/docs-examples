resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"

  bitbucket_data_center_config {
    host_uri = "https://bitbucket-us-central.gcb-test.com"

    webhook_secret_secret_version = "projects/devconnect-terraform-creds/secrets/bbdc-webhook/versions/latest"

    read_authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbdc-read-token/versions/latest"
    }

    authorizer_credential {
      user_token_secret_version = "projects/devconnect-terraform-creds/secrets/bbdc-auth-token/versions/latest"
    }
  }
}
