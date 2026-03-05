resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-${local.name_suffix}"

  http_config {
    basic_authentication {
        username = "devconnectprober@gmail.com"
        password_secret_version = "projects/devconnect-terraform-creds/secrets/http-basic-auth/versions/latest"
    }
    host_uri = "https://devconnectprober.atlassian.net"
  }
}
