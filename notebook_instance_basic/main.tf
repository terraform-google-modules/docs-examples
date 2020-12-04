resource "google_notebooks_instance" "instance" {
  name = "notebooks-instance-${local.name_suffix}"
  location = "us-west1-a"
  machine_type = "e2-medium"
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-latest-cpu"
  }
}
