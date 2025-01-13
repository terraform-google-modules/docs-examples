resource "google_compute_network" "my_network" {
  name = "colab-test-default-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name   = "colab-test-default-${local.name_suffix}"
  network = google_compute_network.my_network.id
  region = "us-central1"
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_colab_runtime_template" "runtime-template" {
  name        = "colab-runtime-template-${local.name_suffix}"
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
    network = google_compute_network.my_network.id
    subnetwork = google_compute_subnetwork.my_subnetwork.id
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
