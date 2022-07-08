resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "my-repository-${local.name_suffix}"
  description   = "example docker repository-${local.name_suffix}"
  format        = "DOCKER"
}
