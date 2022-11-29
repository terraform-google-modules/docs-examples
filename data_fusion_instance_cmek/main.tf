resource "google_data_fusion_instance" "cmek" {
  name   = "my-instance-${local.name_suffix}"
  region = "us-central1"
  type   = "BASIC"

  crypto_key_config {
    key_reference = google_kms_crypto_key.crypto_key.id
  }

  depends_on = [google_kms_crypto_key_iam_binding.crypto_key_binding]
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "my-instance-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id
}

resource "google_kms_key_ring" "key_ring" {
  name     = "my-instance-${local.name_suffix}"
  location = "us-central1"
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_binding" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-datafusion.iam.gserviceaccount.com"
  ]
}

data "google_project" "project" {}
