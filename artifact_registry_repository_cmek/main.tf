resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "my-repository-${local.name_suffix}"
  description   = "example docker repository with cmek"
  format        = "DOCKER"
  kms_key_name  = "kms-key-${local.name_suffix}"
}
