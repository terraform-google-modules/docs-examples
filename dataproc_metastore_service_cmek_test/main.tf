data "google_project" "project" {}

data "google_storage_project_service_account" "gcs_account" {}


resource "google_dataproc_metastore_service" "default" {
  service_id = "example-service-${local.name_suffix}"
  location   = "us-central1"

  encryption_config {
    kms_key = "example-key-${local.name_suffix}"
  }

  hive_metastore_config {
    version = "3.1.2"
  }

  depends_on = [
    google_kms_crypto_key_iam_member.crypto_key_member_1,
    google_kms_crypto_key_iam_member.crypto_key_member_2,
  ]
}

resource "google_kms_crypto_key_iam_member" "crypto_key_member_1" {
  crypto_key_id = "example-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-metastore.iam.gserviceaccount.com"
}

resource "google_kms_crypto_key_iam_member" "crypto_key_member_2" {
  crypto_key_id = "example-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  member = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}
