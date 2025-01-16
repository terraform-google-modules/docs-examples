resource "google_colab_runtime_template" "my_template" {
  name        = "colab-runtime-${local.name_suffix}"
  display_name = "Runtime template full"
  location    = "us-central1"
  description = "Full runtime template"
  machine_spec {
    machine_type     = "n1-standard-2"
    accelerator_type = "NVIDIA_TESLA_T4"
    accelerator_count = "1"
  }

  data_persistent_disk_spec {
    disk_type    = "pd-standard"
    disk_size_gb = 200
  }

  network_spec {
    enable_internet_access = true
  }

  labels = {
    k = "val"
  }

  idle_shutdown_config {
    idle_timeout = "3600s"
  }

  euc_config {
    euc_disabled = true
  }

  shielded_vm_config {
    enable_secure_boot = true
  }

  network_tags = ["abc", "def"]

  encryption_spec {
    kms_key_name = "my-crypto-key-${local.name_suffix}"
  }
}

resource "google_colab_runtime" "runtime" {
  name = "colab-runtime-${local.name_suffix}"
  location = "us-central1" 
  
  notebook_runtime_template_ref {
    notebook_runtime_template = google_colab_runtime_template.my_template.id
  }
  
  display_name = "Runtime full"
  runtime_user = "gterraformtestuser@gmail.com"
  description = "Full runtime"

  depends_on = [
    google_colab_runtime_template.my_template
  ]
}
