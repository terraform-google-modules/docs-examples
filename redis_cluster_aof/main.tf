resource "google_redis_cluster" "cluster-aof" {
  name           = "aof-cluster-${local.name_suffix}"
  shard_count    = 3
  psc_configs {
    network = google_compute_network.consumer_net.id
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
  allow_fewer_zones_deployment = true
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
    mode = "AOF"
    aof_config {
      append_fsync = "EVERYSEC"
    }
  }
  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]
}

resource "google_network_connectivity_service_connection_policy" "default" {
  name = "my-policy-${local.name_suffix}"
  location = "us-central1"
  service_class = "gcp-memorystore-redis"
  description   = "my basic service connection policy"
  network = google_compute_network.consumer_net.id
  psc_config {
    subnetworks = [google_compute_subnetwork.consumer_subnet.id]
  }
}

resource "google_compute_subnetwork" "consumer_subnet" {
  name          = "my-subnet-${local.name_suffix}"
  ip_cidr_range = "10.0.0.248/29"
  region        = "us-central1"
  network       = google_compute_network.consumer_net.id
}

resource "google_compute_network" "consumer_net" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
