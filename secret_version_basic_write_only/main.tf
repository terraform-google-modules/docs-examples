resource "google_secret_manager_secret" "secret-basic-write-only" {
  secret_id = "secret-version-write-only-${local.name_suffix}"
  
  labels = {
    label = "my-label"
  }

  replication {
    auto {}
  }
}


resource "google_secret_manager_secret_version" "secret-version-basic-write-only" {
  secret = google_secret_manager_secret.secret-basic-write-only.id
  secret_data_wo_version = 1
  secret_data_wo = "secret-data-write-only-${local.name_suffix}"
}
