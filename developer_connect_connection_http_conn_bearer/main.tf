resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"

  http_config {
    host_uri = "https://devconnectprober.atlassian.net"
    
    bearer_token_authentication {
      token_secret_version = "projects/devconnect-terraform-creds/secrets/http-bearer-token/versions/latest"
    }
    
  }
}
