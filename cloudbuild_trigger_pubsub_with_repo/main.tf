resource "google_cloudbuildv2_connection" "my-connection" {
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
  name = "my-repo"
  parent_connection = google_cloudbuildv2_connection.my-connection.id
  remote_uri = "https://github.com/myuser/my-repo.git-${local.name_suffix}"
}

resource "google_pubsub_topic" "mytopic" {
  name = "mytopic"
}

resource "google_cloudbuild_trigger" "pubsub-with-repo-trigger" {
  name = "pubsub-with-repo-trigger"
  location = "us-central1"

  pubsub_config {
    topic = google_pubsub_topic.mytopic.id
  }
  source_to_build {
    repository = google_cloudbuildv2_repository.my-repository.id
    ref = "refs/heads/main"
    repo_type = "GITHUB"
  }
  git_file_source {
    path = "cloudbuild.yaml"
    repository = google_cloudbuildv2_repository.my-repository.id
    revision = "refs/heads/main"
    repo_type = "GITHUB"
  }
}
