data "google_project" "project" {
}

resource "google_kms_key_ring" "keyring" {
  name     = "example-key-ring-${local.name_suffix}"
  location = "us-east1"
}

resource "google_kms_crypto_key" "example_key" {
  name     = "example-crypto-key-name-${local.name_suffix}"
  key_ring = google_kms_key_ring.keyring.id
}

# Grant the Encrypter/Decrypter role to the Dataform service agent on the KMS key
resource "google_kms_crypto_key_iam_member" "crypto_key_binding" {
  crypto_key_id = google_kms_crypto_key.example_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com"
}

# Config with KMS key provided
resource "google_dataform_config" "config" {
  region               = "us-east1"
  default_kms_key_name = google_kms_crypto_key.example_key.id

  # Ensure IAM binding is created before the Dataform Config
  depends_on = [
    google_kms_crypto_key_iam_member.crypto_key_binding
  ]
}
