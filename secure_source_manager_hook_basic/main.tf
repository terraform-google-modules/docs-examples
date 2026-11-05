resource "google_secure_source_manager_instance" "instance" {
    location = "asia-east1"
    instance_id = "my-basic-instance-${local.name_suffix}"

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_secure_source_manager_repository" "repository" {
    repository_id = "my-basic-repository-${local.name_suffix}"
    location = google_secure_source_manager_instance.instance.location
    instance = google_secure_source_manager_instance.instance.name

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_secure_source_manager_hook" "default" {
    hook_id = "my-basic-hook-${local.name_suffix}"
    repository_id = google_secure_source_manager_repository.repository.repository_id
    location = google_secure_source_manager_repository.repository.location
    target_uri = "https://www.example.com"
    # default event
    events = ["PUSH"]
}
