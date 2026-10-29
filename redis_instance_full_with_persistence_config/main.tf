resource "google_redis_instance" "cache-persis" {
  name           = "ha-memory-cache-persis-${local.name_suffix}"
  tier           = "STANDARD_HA"
  memory_size_gb = 1
  region                  = "northamerica-south1"
  location_id             = "northamerica-south1-a"
  alternative_location_id = "northamerica-south1-b"

  persistence_config {
    persistence_mode = "RDB"
    rdb_snapshot_period = "TWELVE_HOURS"
  }

  lifecycle {
    prevent_destroy = false
  }
}
