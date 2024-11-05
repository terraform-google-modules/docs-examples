resource "google_memorystore_instance" "instance-full" {
  instance_id = "full-instance-${local.name_suffix}"
  shard_count = 3
  desired_psc_auto_connections {
    network    = google_compute_network.producer_net.id
    project_id = data.google_project.project.project_id
  }
  location                = "us-central1"
  replica_count           = 2
  node_type               = "SHARED_CORE_NANO"
  transit_encryption_mode = "TRANSIT_ENCRYPTION_DISABLED"
  authorization_mode      = "AUTH_DISABLED"
  engine_configs = {
    maxmemory-policy = "volatile-ttl"
  }
  zone_distribution_config {
    mode = "SINGLE_ZONE"
    zone = "us-central1-b"
  }
  engine_version              = "VALKEY_7_2"
  deletion_protection_enabled = false
  mode = "CLUSTER"
  persistence_config {
    mode = "RDB"
    rdb_config {
      rdb_snapshot_period     = "ONE_HOUR"
      rdb_snapshot_start_time = "2024-10-02T15:01:23Z"
    }
  }
  labels = {
    "abc" : "xyz"
  }
  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]

  lifecycle {
    prevent_destroy = "true-${local.name_suffix}"
  }
}

resource "google_network_connectivity_service_connection_policy" "default" {
  name          = "my-policy-${local.name_suffix}"
  location      = "us-central1"
  service_class = "gcp-memorystore"
  description   = "my basic service connection policy"
  network       = google_compute_network.producer_net.id
  psc_config {
    subnetworks = [google_compute_subnetwork.producer_subnet.id]
  }
}

resource "google_compute_subnetwork" "producer_subnet" {
  name          = "my-subnet-${local.name_suffix}"
  ip_cidr_range = "10.0.0.248/29"
  region        = "us-central1"
  network       = google_compute_network.producer_net.id
}

resource "google_compute_network" "producer_net" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

data "google_project" "project" {
}
