data "google_project" "project" {}

resource "google_artifact_registry_repository" "upstream_repo" {
  location      = "us-central1"
  repository_id = "example-upstream-repo-${local.name_suffix}"
  description   = "example upstream repository-${local.name_suffix}"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "example-common-remote-${local.name_suffix}"
  description   = "example remote common repository with docker upstream-${local.name_suffix}"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "pull-through cache of another Artifact Registry repository by URL"
    common_repository {
      uri         = "https://us-central1-docker.pkg.dev/${data.google_project.project.project_id}/example-upstream-repo-${local.name_suffix}"
    }
  }
  depends_on = [google_artifact_registry_repository.upstream_repo]
}
