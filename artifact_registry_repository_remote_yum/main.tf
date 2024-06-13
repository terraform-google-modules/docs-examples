resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "rocky-9-${local.name_suffix}"
  description   = "example remote yum repository-${local.name_suffix}"
  format        = "YUM"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "Rocky 9 remote repository"
    yum_repository {
      public_repository {
        repository_base = "ROCKY"
        repository_path = "pub/rocky/9/BaseOS/x86_64/os"
      }
    }
  }
}
