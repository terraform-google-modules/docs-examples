resource "google_compute_instance" "vm" {
  provider     = google-beta
  name         = "my-vm-${local.name_suffix}"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
  }
}

resource "google_compute_machine_image" "image" {
  provider        = google-beta
  name            = "my-image-${local.name_suffix}"
  source_instance = google_compute_instance.vm.self_link
  machine_image_encryption_key {
    kms_key_name = google_kms_crypto_key.crypto_key.id
  }
}

resource "google_kms_crypto_key" "crypto_key" {
  provider = google-beta
  name     = "key-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_key_ring" "key_ring" {
  provider = google-beta
  name     = "keyring-${local.name_suffix}"
  location = "us"
}
