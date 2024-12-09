resource "google_artifact_registry_repository" "my-repo" {
  repository_id = "my-repository-${local.name_suffix}"
  description   = "example docker repository-${local.name_suffix}"
  location      = "us"
  format        = "DOCKER"
}
