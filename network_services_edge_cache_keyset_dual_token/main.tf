resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "secret-name-${local.name_suffix}"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = google_secret_manager_secret.secret-basic.id

  secret_data = "secret-data"
}

resource "google_network_services_edge_cache_keyset" "default" {
  name        = "my-keyset-${local.name_suffix}"
  description = "The default keyset"
  public_key {
    id      = "my-public-key"
    managed = true
  }
  validation_shared_keys {
    secret_version = google_secret_manager_secret_version.secret-version-basic.id
  }
}
