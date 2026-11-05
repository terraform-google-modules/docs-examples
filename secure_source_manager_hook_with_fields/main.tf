resource "google_secure_source_manager_instance" "instance" {
    location = "asia-east1"
    instance_id = "my-basic-instance-${local.name_suffix}"

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_service_account" "sa" {
    account_id   = "my-basic-sa-${local.name_suffix}"
    display_name = "Test Service Account"
}

resource "google_secure_source_manager_repository" "repository" {
    repository_id = "my-basic-repository-${local.name_suffix}"
    instance = google_secure_source_manager_instance.instance.name
    location = google_secure_source_manager_instance.instance.location
    service_account = google_service_account.sa.email

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

resource "google_secure_source_manager_hook" "default" {
    hook_id = "my-basic-hook-${local.name_suffix}"
    location = google_secure_source_manager_repository.repository.location
    repository_id = google_secure_source_manager_repository.repository.repository_id
    target_uri = "https://www.example.com"
    sensitive_query_string = "auth=fake_token"
    disabled = false
    service_account_auth = true
    push_option {
        branch_filter = "main"
    }
    events = ["PUSH", "PULL_REQUEST", "PULL_REQUEST_COMMENT"]
}
