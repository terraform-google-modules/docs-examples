resource "google_artifact_registry_repository" "default" {
  location      = "us-central1"
  repository_id = "my-repository-${local.name_suffix}"
  description   = "example docker repository-${local.name_suffix}"
  format        = "DOCKER"
}

resource "google_artifact_registry_rule" "my-rule" {
  repository_id = google_artifact_registry_repository.default.repository_id
  location      = google_artifact_registry_repository.default.location
  rule_id       = "my-repo-rule-id-${local.name_suffix}"
  action        = "DENY"
  operation     = "DOWNLOAD"
  condition {
    expression  = "pkg.version.id < '2.0'"
    title       = "Block legacy versions"
    description = "Prevents downloading images with version IDs less than 2.0"
  }
}
