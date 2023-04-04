resource "google_artifact_registry_repository" "my-repo-upstream" {
  location      = "us-central1"
  repository_id = "my-repository-upstream-${local.name_suffix}"
  description   = "example docker repository (upstream source)-${local.name_suffix}"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "my-repo" {
  depends_on    = []
  location      = "us-central1"
  repository_id = "my-repository-${local.name_suffix}"
  description   = "example virtual docker repository-${local.name_suffix}"
  format        = "DOCKER"
  mode          = "VIRTUAL_REPOSITORY"
  virtual_repository_config {
    upstream_policies {
      id          = "my-repository-upstream-${local.name_suffix}"
      repository  = google_artifact_registry_repository.my-repo-upstream.id
      priority    = 1
    }
  }
}
