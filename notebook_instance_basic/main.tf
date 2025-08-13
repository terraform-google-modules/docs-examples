resource "google_notebooks_instance" "instance" {
  name = "notebooks-instance-${local.name_suffix}"
  location = "us-west1-a"
  machine_type = "e2-medium"
  vm_image {
    project      = "cloud-notebooks-managed"
    image_family = "workbench-instances"
  }
}
