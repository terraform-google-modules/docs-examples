resource "google_compute_disk" "default" {
  name  = "test-disk-${local.name_suffix}"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  image = "debian-11-bullseye-v20220719"
  labels = {
    environment = "dev"
  }
  disk_encryption_key {
    raw_key_wo = "SGVsbG8gZnJvbSBHb29nbGUgQ2xvdWQgUGxhdGZvcm0="
    raw_key_wo_version = 1
  }
  physical_block_size_bytes = 4096
}
