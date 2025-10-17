resource "google_secure_source_manager_instance" "instance" {
    location = "us-central1"
    instance_id = "my-initial-instance-${local.name_suffix}"

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_secure_source_manager_repository" "repository" {
    repository_id = "my-initial-repository-${local.name_suffix}"
    instance = google_secure_source_manager_instance.instance.name
    location = google_secure_source_manager_instance.instance.location

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_secure_source_manager_hook" "default" {
    hook_id = "my-initial-hook-${local.name_suffix}"
    location = google_secure_source_manager_repository.repository.location
    repository_id = google_secure_source_manager_repository.repository.repository_id
    target_uri = "https://www.example.com"
    sensitive_query_string = "auth=fake_token"
    disabled = false
    push_option {
        branch_filter = "main"
    }
    events = ["PUSH", "PULL_REQUEST"]
}
