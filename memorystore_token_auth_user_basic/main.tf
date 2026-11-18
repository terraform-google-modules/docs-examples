resource "google_memorystore_instance" "user-basic-instance" {
  instance_id                 = "user-basic-instance-${local.name_suffix}"
  shard_count                 = 1
  node_type                   = "SHARED_CORE_NANO"
  location                    = "europe-west4"
  authorization_mode          = "TOKEN_AUTH"
  deletion_protection_enabled = false
}

resource "google_memorystore_token_auth_user" "user-basic" {
  instance                    = google_memorystore_instance.user-basic-instance.instance_id
  user_id                     = "user-basic-user-${local.name_suffix}"
  location                    = "europe-west4"
}
