resource "google_notebooks_instance" "instance" {
  name = "notebooks-instance-${local.name_suffix}"
  location = "us-west1-a"
  machine_type = "n1-standard-1" // can't be e2 because of accelerator

  install_gpu_driver = true
  accelerator_config {
    type         = "NVIDIA_TESLA_T4"
    core_count   = 1
  }
  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "pytorch-latest-cu124"
  }
}
