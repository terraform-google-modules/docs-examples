resource "google_secret_manager_secret" "secret-with-version-destroy-ttl" {
  secret_id = "secret-${local.name_suffix}"

  version_destroy_ttl = "2592000s"

  replication {
    auto {}
  }
}
