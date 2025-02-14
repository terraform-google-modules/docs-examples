resource "google_redis_cluster" "cluster-cmek" {
  name           = "cmek-cluster-${local.name_suffix}"
  shard_count    = 3
  psc_configs {
    network = google_compute_network.consumer_net.id
  }
  kms_key = "my-key-${local.name_suffix}"
  region = "us-central1"
  deletion_protection_enabled = false
  depends_on = [
    google_network_connectivity_service_connection_policy.default
  ]
}


data "google_project" "project" {
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
