resource "google_secure_source_manager_instance" "instance" {
    location = "us-central1"
    instance_id = "my-instance-${local.name_suffix}"

    # For preventing accidental deletions
    lifecycle {
      prevent_destroy = "false"
    }
}

resource "google_secure_source_manager_repository" "default" {
    location = "us-central1"
    repository_id = "my-repository-${local.name_suffix}"
    instance = google_secure_source_manager_instance.instance.name

    description = "This is a test repository"
    initial_config {
      default_branch = "main"
      gitignores = ["python"]
      license = "mit"
      readme = "default"
    }

    # Prevent accidental deletions.
    lifecycle {
      prevent_destroy = "false"
    }
}
