resource "google_redis_instance" "cache-persis" {
  name           = "ha-memory-cache-persis-${local.name_suffix}"
  tier           = "STANDARD_HA"
  memory_size_gb = 1
  region                  = "us-west1"
  location_id             = "us-west1-a"
  alternative_location_id = "us-west1-b"

  persistence_config {
    persistence_mode = "RDB"
    rdb_snapshot_period = "TWELVE_HOURS"
  }

  lifecycle {
    prevent_destroy = false
  }
}
