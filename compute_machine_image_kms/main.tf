resource "google_compute_instance" "vm" {
  provider     = google-beta
  name         = "vm-${local.name_suffix}"
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
  name            = "image-${local.name_suffix}"
  source_instance = google_compute_instance.vm.self_link
  machine_image_encryption_key {
    kms_key_name = google_kms_crypto_key.crypto_key.id
  }
  depends_on = [google_project_iam_member.kms-project-binding]
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

data "google_project" "project" {
  provider = google-beta
}

resource "google_project_iam_member" "kms-project-binding" {
  provider = google-beta
  project  = data.google_project.project.project_id
  role     = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member   = "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
}
