resource "google_discovery_engine_cmek_config" "default" {
  location            = "us"
  cmek_config_id      = "cmek-config-id-${local.name_suffix}"
  kms_key             = "kms-key-name-${local.name_suffix}"
  depends_on = [google_kms_crypto_key_iam_member.crypto_key]
}

data "google_project" "project" {}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = "kms-key-name-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-discoveryengine.iam.gserviceaccount.com"
}
