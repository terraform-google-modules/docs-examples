resource "google_compute_disk" "default" {
  name  = "test-disk-features-${local.name_suffix}"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  labels = {
    environment = "dev"
  }

  guest_os_features {
    type = "SECURE_BOOT"
  }

  guest_os_features {
    type = "MULTI_IP_SUBNET"
  }

  guest_os_features {
    type = "WINDOWS"
  }

  licenses = ["https://www.googleapis.com/compute/v1/projects/windows-cloud/global/licenses/windows-server-core"]

  physical_block_size_bytes = 4096
}
