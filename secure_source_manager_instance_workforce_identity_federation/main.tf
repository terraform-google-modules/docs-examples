resource "google_secure_source_manager_instance" "default" {
    location = "us-central1"
    instance_id = "my-instance-${local.name_suffix}"

    workforce_identity_federation_config {
      enabled = true
    }

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}
