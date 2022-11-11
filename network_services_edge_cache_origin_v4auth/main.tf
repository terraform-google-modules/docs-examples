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

resource "google_network_services_edge_cache_origin" "default" {
  name           = "my-origin-${local.name_suffix}"
  origin_address = "gs://media-edge-default"
  description    = "The default bucket for V4 authentication"
  aws_v4_authentication {
    access_key_id             = "ACCESSKEYID"
    secret_access_key_version = google_secret_manager_secret_version.secret-version-basic.id
    origin_region             = "auto"
  }
}
