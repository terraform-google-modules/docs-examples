data "google_project" "project" {
}

resource "google_sourcerepo_repository" "git_repository" {
  name = "my/repository-${local.name_suffix}"
}

resource "google_secret_manager_secret" "secret" {
  secret_id = "my-secret-${local.name_suffix}"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret = google_secret_manager_secret.secret.id

  secret_data = "secret-data-${local.name_suffix}"
}

resource "google_kms_key_ring" "keyring" {
  
  name     = "example-key-ring-${local.name_suffix}"
  location = "us-central1"
}

resource "google_kms_crypto_key" "example_key" {
  
  name            = "example-crypto-key-name-${local.name_suffix}"
  key_ring        = google_kms_key_ring.keyring.id
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_binding" {

  crypto_key_id = google_kms_crypto_key.example_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-dataform.iam.gserviceaccount.com",
  ]
}

resource "google_dataform_repository" "dataform_repository" {
  name = "dataform_repository-${local.name_suffix}"
  display_name = "dataform_repository-${local.name_suffix}"
  npmrc_environment_variables_secret_version = google_secret_manager_secret_version.secret_version.id
  kms_key_name = google_kms_crypto_key.example_key.id
  deletion_policy = "FORCE"

  labels = {
    label_foo1 = "label-bar1"
  }

  git_remote_settings {
      url = google_sourcerepo_repository.git_repository.url
      default_branch = "main"
      authentication_token_secret_version = google_secret_manager_secret_version.secret_version.id
  }

  workspace_compilation_overrides {
    default_database = "database"
    schema_suffix = "_suffix"
    table_prefix = "prefix_"
  }

  depends_on = [
    google_kms_crypto_key_iam_binding.crypto_key_binding
  ]
}
