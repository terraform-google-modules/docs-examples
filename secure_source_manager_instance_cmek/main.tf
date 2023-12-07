resource "google_kms_key_ring" "key_ring" {
  name     = "my-keyring-${local.name_suffix}"
  location = "us-central1"
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "my-key-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_binding" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-sourcemanager.iam.gserviceaccount.com"
  ]
}

resource "google_secure_source_manager_instance" "default" {
    location = "us-central1"
    instance_id = "my-instance-${local.name_suffix}"
    kms_key = google_kms_crypto_key.crypto_key.id
}

data "google_project" "project" {}
