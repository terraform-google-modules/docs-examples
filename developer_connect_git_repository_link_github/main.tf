resource "google_developer_connect_git_repository_link" "primary" {
  git_repository_link_id              = "my-repository-${local.name_suffix}"
  parent_connection = google_developer_connect_connection.github_conn.connection_id
  clone_uri        = "https://github.com/gcb-developerconnect-robot/tf-demo.git"
  location          = "us-central1"
  annotations       = {}
}

resource "google_developer_connect_connection" "github_conn" {
  
  location = "us-central1"
  connection_id     = "my-connection-${local.name_suffix}"
  disabled = false

  github_config {
    github_app = "DEVELOPER_CONNECT"
    app_installation_id = 49439208

    authorizer_credential {
      oauth_token_secret_version = "projects/devconnect-terraform-creds/secrets/tf-test-do-not-change-github-oauthtoken-e0b9e7/versions/1"
    }
  }
}