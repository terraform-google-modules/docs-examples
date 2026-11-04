resource "google_redis_cluster" "user-basic-cluster" {
  name                        = "user-basic-cluster-${local.name_suffix}"
  shard_count                 = 1
  region                      = "europe-west4"
  authorization_mode          = "AUTH_MODE_TOKEN_AUTH"
  deletion_protection_enabled = false
}

resource "google_redis_cluster_token_auth_user" "user-basic" {
  cluster                     = google_redis_cluster.user-basic-cluster.name
  user_id                     = "user-basic-user-${local.name_suffix}"
  region                      = "europe-west4"
}
