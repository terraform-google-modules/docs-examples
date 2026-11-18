resource "google_memorystore_instance" "instance" {
  instance_id                 = "token-rotation-instance-${local.name_suffix}"
  shard_count                 = 1
  node_type                   = "SHARED_CORE_NANO"
  location                    = "europe-west4"
  authorization_mode          = "TOKEN_AUTH"
  deletion_protection_enabled = false
}

resource "google_memorystore_auth_token" "token-1" {
  instance = google_memorystore_instance.instance.instance_id
  user_id  = "default"
  token_id = "version-1"
  location = "europe-west4"
}

resource "google_memorystore_auth_token" "token-2" {
  instance   = google_memorystore_instance.instance.instance_id
  user_id    = "default"
  location   = "europe-west4"
  depends_on = [google_memorystore_auth_token.token-1]
}
