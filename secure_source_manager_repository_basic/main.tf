resource "google_secure_source_manager_instance" "instance" {
    location = "us-central1"
    instance_id = "my-instance-${local.name_suffix}"

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_secure_source_manager_repository" "default" {
    location = "us-central1"
    repository_id = "my-repository-${local.name_suffix}"
    instance = google_secure_source_manager_instance.instance.name

    # Prevent accidental deletions.
    lifecycle {
      prevent_destroy = "false"
    }
}
