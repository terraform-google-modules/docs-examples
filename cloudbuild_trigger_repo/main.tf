resource "google_cloudbuildv2_connection" "my-connection" {
  location = "us-central1"
  name = "my-connection-${local.name_suffix}"

  github_config {
    app_installation_id = 123123-${local.name_suffix}
    authorizer_credential {
      oauth_token_secret_version = "projects/my-project/secrets/github-pat-secret/versions/latest-${local.name_suffix}"
    }
  }
}

resource "google_cloudbuildv2_repository" "my-repository" {
  name = "my-repo-${local.name_suffix}"
  parent_connection = google_cloudbuildv2_connection.my-connection.id
  remote_uri = "https://github.com/myuser/my-repo.git-${local.name_suffix}"
}

resource "google_cloudbuild_trigger" "repo-trigger" {
  location = "us-central1"

  repository_event_config {
    repository = google_cloudbuildv2_repository.my-repository.id
    push {
      branch = "feature-.*"
    }
  }

  filename = "cloudbuild.yaml"
}
