resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "debian-buster-${local.name_suffix}"
  description   = "example remote apt repository-${local.name_suffix}"
  format        = "APT"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "Debian buster remote repository"
    apt_repository {
      public_repository {
        repository_base = "DEBIAN"
        repository_path = "debian/dists/buster"
      }
    }
  }
}
