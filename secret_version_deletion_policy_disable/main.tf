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

resource "google_secret_manager_secret_version" "secret-version-deletion-policy" {
  secret = google_secret_manager_secret.secret-basic.id

  secret_data = "secret-data-${local.name_suffix}"
  deletion_policy = "DISABLE"
}
