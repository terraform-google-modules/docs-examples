resource "google_vertex_ai_tensorboard" "tensorboard" {
  display_name = "terraform-${local.name_suffix}"
  description  = "sample description"
  labels       = {
    "key1" : "value1",
    "key2" : "value2"
  }
  region       = "us-central1"
  encryption_spec {
    kms_key_name = "kms-name-${local.name_suffix}"
  }
  depends_on = [google_kms_crypto_key_iam_member.crypto_key]
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = "kms-name-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform.iam.gserviceaccount.com"
}

data "google_project" "project" {}
