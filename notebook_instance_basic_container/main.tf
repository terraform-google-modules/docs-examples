resource "google_notebooks_instance" "instance" {
  name = "notebooks-instance-${local.name_suffix}"
  location = "us-west1-a"
  machine_type = "e2-medium"
  metadata = {
    proxy-mode = "service_account"
    terraform  = "true"
  }
  container_image {
    repository = "gcr.io/deeplearning-platform-release/base-cpu"
    tag = "latest"
  }
}
