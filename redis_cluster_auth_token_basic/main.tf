resource "google_redis_cluster" "token-basic-cluster" {
  name                        = "token-basic-cluster-${local.name_suffix}"
  shard_count                 = 1
  region                      = "europe-west4"
  authorization_mode          = "AUTH_MODE_TOKEN_AUTH"
  deletion_protection_enabled = false
}

resource "google_redis_cluster_token_auth_user" "token-basic-user" {
  cluster                     = google_redis_cluster.token-basic-cluster.name
  user_id                     = "token-basic-user-${local.name_suffix}"
  region                      = "europe-west4"
}

resource "google_redis_cluster_auth_token" "token-basic" {
  cluster                     = google_redis_cluster.token-basic-cluster.name
  user_id                     = google_redis_cluster_token_auth_user.token-basic-user.user_id
  region                      = "europe-west4"
}
