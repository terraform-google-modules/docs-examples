resource "google_kms_key_ring" "keyring" {
  name     = "key-ring-${local.name_suffix}"
  location = "us-central1"
}

resource "google_kms_crypto_key" "crypto_key" {
  name            = "crypto-name-${local.name_suffix}"
  key_ring        = google_kms_key_ring.keyring.id
  # rotation_period = "7776000s"
}

resource "google_netapp_kmsconfig" "kmsConfig" {
  name = "kms-test-${local.name_suffix}"
  description="this is a test description"
  crypto_key_name=google_kms_crypto_key.crypto_key.id
  location="us-central1"
}
