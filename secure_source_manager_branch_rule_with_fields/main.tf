resource "google_secure_source_manager_instance" "instance" {
    location = "us-central1"
    instance_id = "my-initial-instance-${local.name_suffix}"
    # Prevent accidental deletions.
    lifecycle {
        prevent_destroy = "false"
    }
}

resource "google_secure_source_manager_repository" "repository" {
    repository_id = "my-initial-repository-${local.name_suffix}"
    instance = google_secure_source_manager_instance.instance.name
    location = google_secure_source_manager_instance.instance.location
    # Prevent accidental deletions.
    lifecycle {
        prevent_destroy = "false"
    }
}

resource "google_secure_source_manager_branch_rule" "default" {
    branch_rule_id = "my-initial-branchrule-${local.name_suffix}"
    location = google_secure_source_manager_repository.repository.location
    repository_id = google_secure_source_manager_repository.repository.repository_id
    include_pattern = "test"
    minimum_approvals_count   = 2
    minimum_reviews_count     = 2
    require_comments_resolved = true
    require_linear_history    = true
    require_pull_request      = true
    disabled = false
    allow_stale_reviews = false
}
