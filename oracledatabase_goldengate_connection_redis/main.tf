resource "google_oracle_database_goldengate_connection" "connection" {
  goldengate_connection_id = "my-connection-${local.name_suffix}"
  location                 = "us-east4"
  project                  = "my-project-${local.name_suffix}"
  gcp_oracle_zone          = "us-east4-b-r1"

  properties {
    display_name    = "my-connection-${local.name_suffix} display name"
    connection_type = "REDIS"
    redis_connection_properties {
      technology_type     = "REDIS"
      servers             = "redis-shard1.example.com:6379,redis-shard2.example.com:6379"
      security_protocol   = "PLAIN"
      authentication_type = "BASIC"
      username            = "redis_agent"
      password            = "RedisSecureCacheP@ssword123!"
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}
