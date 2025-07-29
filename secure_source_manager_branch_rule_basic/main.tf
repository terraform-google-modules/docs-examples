resource "google_secure_source_manager_instance" "instance" {
    location = "us-central1"
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

resource "google_secure_source_manager_branch_rule" "basic" {
    branch_rule_id = "my-basic-branchrule-${local.name_suffix}"
    repository_id = google_secure_source_manager_repository.repository.repository_id
    location = google_secure_source_manager_repository.repository.location
    # This field is required for BranchRule creation
    include_pattern = "main"
}
