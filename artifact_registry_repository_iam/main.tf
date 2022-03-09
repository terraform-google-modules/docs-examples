resource "google_artifact_registry_repository" "my-repo" {
  provider = google-beta

  location = "us-central1"
  repository_id = "my-repository-${local.name_suffix}"
  description = "example docker repository with iam-${local.name_suffix}"
  format = "DOCKER"
}

resource "google_service_account" "test-account" {
  provider = google-beta

  account_id   = "my-account-${local.name_suffix}"
  display_name = "Test Service Account"
}

resource "google_artifact_registry_repository_iam_member" "test-iam" {
  provider = google-beta

  location = google_artifact_registry_repository.my-repo.location
  repository = google_artifact_registry_repository.my-repo.name
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.test-account.email}"
}
