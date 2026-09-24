resource "google_secret_manager_regional_secret" "secret-basic-write-only" {
  secret_id = "regional-secret-version-write-only-${local.name_suffix}"
  location  = "us-central1"

  labels = {
    label = "my-label"
  }
}

resource "google_secret_manager_regional_secret_version" "regional-secret-version-basic-write-only" {
  secret                 = google_secret_manager_regional_secret.secret-basic-write-only.id
  secret_data_wo_version = 1
  secret_data_wo         = "regional-secret-data-write-only-${local.name_suffix}"
}
