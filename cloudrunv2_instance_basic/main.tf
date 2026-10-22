resource "google_cloud_run_v2_instance" "default" {
  name     = "cloudrun-instance-${local.name_suffix}"
  location = "us-west4"

  containers {
    image = "us-docker.pkg.dev/cloudrun/container/hello"
  }
}
