resource "google_redis_instance" "cache-persis" {
  name           = "ha-memory-cache-persis-${local.name_suffix}"
  tier           = "STANDARD_HA"
  memory_size_gb = 1
  region                  = "us-east1"
  location_id             = "us-east1-b"
  alternative_location_id = "us-east1-c"

  persistence_config {
    persistence_mode = "RDB"
    rdb_snapshot_period = "TWELVE_HOURS"
  }

  lifecycle {
    prevent_destroy = false
  }
}
