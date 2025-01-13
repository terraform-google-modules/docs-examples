resource "google_colab_runtime_template" "runtime-template" {
  name = "colab-runtime-template-${local.name_suffix}"
  display_name = "Runtime template basic"
  location = "us-central1"

  machine_spec {
    machine_type     = "e2-standard-4"
  }

  network_spec {
    enable_internet_access = true
  }
}
