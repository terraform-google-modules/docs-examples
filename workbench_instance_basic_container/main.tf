resource "google_workbench_instance" "instance" {
  name = "workbench-instance-${local.name_suffix}"
  location = "us-west1-a"

  gce_setup {
    container_image {
      repository = "us-docker.pkg.dev/deeplearning-platform-release/gcr.io/base-cu113.py310"
      tag = "latest"
    }
  }
}
