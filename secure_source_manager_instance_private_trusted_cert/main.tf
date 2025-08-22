resource "google_secure_source_manager_instance" "default" {
  instance_id = "my-instance-${local.name_suffix}"
  location    = "us-central1"

  private_config {
    is_private = true
  }
  deletion_policy = "DELETE"
}
