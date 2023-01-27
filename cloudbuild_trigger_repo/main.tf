resource "google_cloudbuildv2_connection" "my-connection" {
  provider = google-beta
  location = "us-central1"
  name = "my-connection"

  github_config {
    app_installation_id = 123123-${local.name_suffix}
    authorizer_credential {
      oauth_token_secret_version = "projects/my-project/secrets/github-pat-secret/versions/latest-${local.name_suffix}"
    }
  }
}

resource "google_cloudbuildv2_repository" "my-repository" {
  provider = google-beta
  name = "my-repo"
  parent_connection = google_cloudbuildv2_connection.my-connection.id
  remote_uri = "https://github.com/myuser/my-repo.git-${local.name_suffix}"
}

resource "google_cloudbuild_trigger" "repo-trigger" {
  provider = google-beta
  location = "us-central1"

  repository_event_config {
    repository = google_cloudbuildv2_repository.my-repository.id
    push {
      branch = "feature-.*"
    }
  }

  filename = "cloudbuild.yaml"
}
