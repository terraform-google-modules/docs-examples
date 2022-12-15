resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  repository_id = "my-repository-${local.name_suffix}"
  description   = "example docker repository with cmek"
  format        = "DOCKER"
  kms_key_name  = "kms-key-${local.name_suffix}"
  depends_on = [
    google_kms_crypto_key_iam_member.crypto_key
  ]
}

resource "google_kms_crypto_key_iam_member" "crypto_key" {
  crypto_key_id = "kms-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}

data "google_project" "project" {}
