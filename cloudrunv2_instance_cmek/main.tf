resource "google_cloud_run_v2_instance" "default" {
  name                             = "cloudrun-instance-${local.name_suffix}"
  location                         = "us-east4"
  encryption_key                   = "my-key-${local.name_suffix}"
  encryption_key_revocation_action = "SHUTDOWN"
  encryption_key_shutdown_duration = "3600s"

  containers {
    image = "us-docker.pkg.dev/cloudrun/container/hello"
  }
}
