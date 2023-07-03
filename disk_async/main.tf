resource "google_compute_disk" "primary" {
  name  = "async-test-disk-${local.name_suffix}"
  type  = "pd-ssd"
  zone  = "us-central1-a"

  physical_block_size_bytes = 4096
}

resource "google_compute_disk" "secondary" {
  name  = "async-secondary-test-disk-${local.name_suffix}"
  type  = "pd-ssd"
  zone  = "us-east1-c"

  async_primary_disk {
    disk = google_compute_disk.primary.id
  }

  physical_block_size_bytes = 4096
}
