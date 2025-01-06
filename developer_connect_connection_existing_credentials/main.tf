resource "google_developer_connect_connection" "my-connection" {
  location = "us-central1"
  connection_id = "tf-test-connection-cred-${local.name_suffix}"

  github_config {
    github_app = "DEVELOPER_CONNECT"

    authorizer_credential {
      oauth_token_secret_version = "projects/your-project/secrets/your-secret-id/versions/latest-${local.name_suffix}"
    }
  }
}

output "next_steps" {
  description = "Follow the action_uri if present to continue setup"
  value = google_developer_connect_connection.my-connection.installation_state
}
