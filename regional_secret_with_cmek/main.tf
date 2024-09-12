data "google_project" "project" {}

resource "google_kms_crypto_key_iam_member" "kms-secret-binding" {
  crypto_key_id = "kms-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-secretmanager.iam.gserviceaccount.com"
}

resource "google_secret_manager_regional_secret" "regional-secret-with-cmek" {
  secret_id = "tf-reg-secret-${local.name_suffix}"
  location = "us-central1"

  customer_managed_encryption {
    kms_key_name = "kms-key-${local.name_suffix}"
  }

  depends_on = [ google_kms_crypto_key_iam_member.kms-secret-binding ]
}
