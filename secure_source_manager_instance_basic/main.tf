resource "google_secure_source_manager_instance" "default" {
    location = "us-central1"
    instance_id = "my-instance-${local.name_suffix}"
    labels = {
      "foo" = "bar"
    }

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}
