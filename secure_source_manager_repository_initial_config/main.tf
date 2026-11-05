resource "google_secure_source_manager_instance" "instance" {
    location = "asia-east1"
    instance_id = "my-instance-${local.name_suffix}"

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_service_account" "sa" {
    account_id   = "my-sa-${local.name_suffix}"
    display_name = "Test Service Account"
}

resource "google_secure_source_manager_repository" "default" {
    location = "asia-east1"
    repository_id = "my-repository-${local.name_suffix}"
    instance = google_secure_source_manager_instance.instance.name

    description = "This is a test repository"
    service_account = google_service_account.sa.email
    initial_config {
      default_branch = "main"
      gitignores = ["python"]
      license = "mit"
      readme = "default"
    }

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}
