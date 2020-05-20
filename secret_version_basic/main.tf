resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-version-${local.name_suffix}"
  
  labels = {
    label = "my-label"
  }

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = google_secret_manager_secret.secret-basic.id

  secret_data = "secret-data-${local.name_suffix}"
}
