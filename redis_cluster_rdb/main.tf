resource "google_redis_cluster" "cluster-rdb" {
  name           = "rdb-cluster-${local.name_suffix}"
  shard_count    = 3
  psc_configs {
    network = google_compute_network.producer_net.id
  }
  region = "us-central1"
  replica_count = 0
  node_type = "REDIS_SHARED_CORE_NANO"
  transit_encryption_mode = "TRANSIT_ENCRYPTION_MODE_DISABLED"
  authorization_mode = "AUTH_MODE_DISABLED"
  redis_configs = {
    maxmemory-policy	= "volatile-ttl"
  }
  deletion_protection_enabled = false

  zone_distribution_config {
    mode = "MULTI_ZONE"
  }
  maintenance_policy {
    weekly_maintenance_window {
      day = "MONDAY"
      start_time {
        hours = 1
        minutes = 0
        seconds = 0
        nanos = 0
      }
    }
  }
  persistence_config { 
    mode = "RDB"
    rdb_config {
      rdb_snapshot_period = "ONE_HOUR"
      rdb_snapshot_start_time = "2024-10-02T15:01:23Z"
    }
  }
  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]
}

resource "google_network_connectivity_service_connection_policy" "default" {
  name = "mypolicy-${local.name_suffix}"
  location = "us-central1"
  service_class = "gcp-memorystore-redis"
  description   = "my basic service connection policy"
  network = google_compute_network.producer_net.id
  psc_config {
    subnetworks = [google_compute_subnetwork.producer_subnet.id]
  }
}

resource "google_compute_subnetwork" "producer_subnet" {
  name          = "mysubnet-${local.name_suffix}"
  ip_cidr_range = "10.0.0.248/29"
  region        = "us-central1"
  network       = google_compute_network.producer_net.id
}

resource "google_compute_network" "producer_net" {
  name                    = "mynetwork-${local.name_suffix}"
  auto_create_subnetworks = false
}
