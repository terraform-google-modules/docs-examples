resource "google_memorystore_instance" "instance" {
  instance_id                 = "token-rotation-instance-${local.name_suffix}"
  shard_count                 = 1
  node_type                   = "SHARED_CORE_NANO"
  location                    = "europe-west4"
  authorization_mode          = "TOKEN_AUTH"
  deletion_protection_enabled = false
}

resource "google_memorystore_auth_token" "token-2" {
  instance        = google_memorystore_instance.instance.instance_id
  user_id         = "default"
  deletion_policy = "ABANDON"
  location        = "europe-west4"
}
