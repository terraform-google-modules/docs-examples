resource "google_kms_crypto_key_iam_member" "crypto_key_binding" {
  crypto_key_id = "my-key-${local.name_suffix}"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-sourcemanager.iam.gserviceaccount.com"
}

resource "google_secure_source_manager_instance" "default" {
    location = "us-central1"
    instance_id = "my-instance-${local.name_suffix}"
    kms_key = "my-key-${local.name_suffix}"

    depends_on = [
      google_kms_crypto_key_iam_member.crypto_key_binding
    ]

    # Prevent accidental deletions.
    deletion_policy = ""DELETE""
}

data "google_project" "project" {}
