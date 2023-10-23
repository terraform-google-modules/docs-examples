data "google_tpu_v2_runtime_versions" "available" {
  provider = google-beta
}

data "google_tpu_v2_accelerator_types" "available" {
  provider = google-beta
}

resource "google_tpu_v2_vm" "tpu" {
  provider = google-beta

  name = "test-tpu-${local.name_suffix}"
  zone = "us-central1-c"
  description = "Text description of the TPU."

  runtime_version  = "tpu-vm-tf-2.13.0"
  accelerator_type = "v2-8"

  cidr_block = "10.0.0.0/29"

  network_config {
    can_ip_forward      = true
    enable_external_ips = true
    network             = google_compute_network.network.id
    subnetwork          = google_compute_subnetwork.subnet.id
  }
  
  scheduling_config {
    preemptible = true
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  service_account {
    email = google_service_account.sa.email
    scope = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  data_disks {
    source_disk = google_compute_disk.disk.id
    mode        = "READ_ONLY"
  }

  labels = {
    foo = "bar"
  }

  metadata = {
    foo = "bar"
  }

  tags = ["foo"]
}

resource "google_compute_subnetwork" "subnet" {
  provider = google-beta

  name          = "tpu-subnet-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.network.id
}

resource "google_compute_network" "network" {
  provider = google-beta

  name                    = "tpu-net-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_service_account" "sa" {
  provider = google-beta

  account_id   = "tpu-sa-${local.name_suffix}"
  display_name = "Test TPU VM"
}

resource "google_compute_disk" "disk" {
  provider = google-beta

  name  = "tpu-disk-${local.name_suffix}"
  image = "debian-cloud/debian-11"
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-c"
}
