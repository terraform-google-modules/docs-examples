resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version-${local.name_suffix}"

  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret-version-base64" {
  secret = google_secret_manager_secret.secret-basic.id

  is_secret_data_base64 = true
  secret_data = filebase64("secret-data.pfx-${local.name_suffix}")
}
