data "google_project" "default" {
}

data "google_kms_key_ring" "keyring" {
  name     = "my-keyring-${local.name_suffix}"
  location = "us-east1"
}

data "google_kms_crypto_key" "cryptokey" {
  name = "my-crypto-key-${local.name_suffix}"
  key_ring = data.google_kms_key_ring.keyring.id
}

data "google_kms_crypto_key_version" "test_key" {
  crypto_key = data.google_kms_crypto_key.cryptokey.id
}

resource "google_service_account" "service_account" {
  account_id   = "service-acc-${local.name_suffix}"
  display_name = "Service Account"
}

resource "google_integrations_client" "example" {
  location = "us-east1"
  create_sample_integrations = true
  run_as_service_account = google_service_account.service_account.email
  cloud_kms_config {
    kms_location = "us-east1"
    kms_ring = basename(data.google_kms_key_ring.keyring.id)
    key = basename(data.google_kms_crypto_key.cryptokey.id)
    key_version = basename(data.google_kms_crypto_key_version.test_key.id)
    kms_project_id = data.google_project.default.project_id
  }
}
