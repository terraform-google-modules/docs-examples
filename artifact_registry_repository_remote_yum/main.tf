resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "centos-8-${local.name_suffix}"
  description   = "example remote yum repository-${local.name_suffix}"
  format        = "YUM"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "Centos 8 remote repository"
    yum_repository {
      public_repository {
        repository_base = "CENTOS"
        repository_path = "8-stream/BaseOs/x86_64/os"
      }
    }
  }
}
