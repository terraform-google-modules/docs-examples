resource "google_artifact_registry_repository" "my-repo-upstream-1" {
  location      = "us-central1"
  repository_id = "my-repository-upstream-${local.name_suffix}-1"
  description   = "example docker repository (upstream source)-${local.name_suffix} 1"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "my-repo-upstream-2" {
  location      = "us-central1"
  repository_id = "my-repository-upstream-${local.name_suffix}-2"
  description   = "example docker repository (upstream source)-${local.name_suffix} 2"
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
      id          = "my-repository-upstream-${local.name_suffix}-1"
      repository  = google_artifact_registry_repository.my-repo-upstream-1.id
      priority    = 20
    }
    upstream_policies {
      id          = "my-repository-upstream-${local.name_suffix}-2"
      repository  = google_artifact_registry_repository.my-repo-upstream-2.id
      priority    = 10
    }
  }
}
