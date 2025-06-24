// Primary instance
resource "google_memorystore_instance" "primary_instance" {
  instance_id                    = "primary-instance-${local.name_suffix}"
  shard_count                    = 1
  desired_auto_created_endpoints {
    network                      = google_compute_network.primary_producer_net.id
    project_id                   = data.google_project.project.project_id
  }
  location                       = "asia-east1"
  replica_count                  = 1
  node_type                      = "SHARED_CORE_NANO"
  transit_encryption_mode        = "TRANSIT_ENCRYPTION_DISABLED"
  authorization_mode             = "AUTH_DISABLED"
  engine_configs = {
    maxmemory-policy             = "volatile-ttl"
  }
  zone_distribution_config {
    mode                         = "SINGLE_ZONE"
    zone                         = "asia-east1-c"
  }
  deletion_protection_enabled    = false
  persistence_config {
    mode                         = "RDB"
    rdb_config {
      rdb_snapshot_period        = "ONE_HOUR"
      rdb_snapshot_start_time    = "2024-10-02T15:01:23Z"
    }
  }
  labels = {
    "abc" : "xyz"
  }
  depends_on                     = [google_network_connectivity_service_connection_policy.primary_policy]

  lifecycle {
    prevent_destroy              =  false
  }
}

resource "google_network_connectivity_service_connection_policy" "primary_policy" {
  name                           = "my-policy-primary-instance-${local.name_suffix}"
  location                       = "asia-east1"
  service_class                  = "gcp-memorystore"
  description                    = "my basic service connection policy"
  network                        = google_compute_network.primary_producer_net.id
  psc_config {                 
    subnetworks                  = [google_compute_subnetwork.primary_producer_subnet.id]
  }
}

resource "google_compute_subnetwork" "primary_producer_subnet" {
  name                           = "my-subnet-primary-instance-${local.name_suffix}"
  ip_cidr_range                  = "10.0.1.0/29"
  region                         = "asia-east1"
  network                        = google_compute_network.primary_producer_net.id
}

resource "google_compute_network" "primary_producer_net" {
  name                           = "my-network-primary-instance-${local.name_suffix}"
  auto_create_subnetworks        = false
}

// Secondary instance
resource "google_memorystore_instance" "secondary_instance" {
  instance_id                    = "secondary-instance-${local.name_suffix}"
  shard_count                    = 1
  desired_auto_created_endpoints {
    network                      = google_compute_network.secondary_producer_net.id
    project_id                   = data.google_project.project.project_id
  }
  location                       = "europe-north1"
  replica_count                  = 1
  node_type                      = "SHARED_CORE_NANO"
  transit_encryption_mode        = "TRANSIT_ENCRYPTION_DISABLED"
  authorization_mode             = "AUTH_DISABLED"
  engine_configs = {
    maxmemory-policy             = "volatile-ttl"
  }
  zone_distribution_config {
    mode                         = "SINGLE_ZONE"
    zone                         = "europe-north1-c"
  }
  deletion_protection_enabled    = false
  // Cross instance replication config
  cross_instance_replication_config {
    instance_role                 = "SECONDARY"
    primary_instance {
      instance                    = google_memorystore_instance.primary_instance.id
    }
  }
  persistence_config {
    mode                         = "RDB"
    rdb_config {
      rdb_snapshot_period        = "ONE_HOUR"
      rdb_snapshot_start_time    = "2024-10-02T15:01:23Z"
    }
  }
  labels = {
    "abc" : "xyz"
  }
  depends_on                     = [google_network_connectivity_service_connection_policy.secondary_policy]

  lifecycle {
    prevent_destroy              = false
  }
}

resource "google_network_connectivity_service_connection_policy" "secondary_policy" {
  name                           = "my-policy-secondary-instance-${local.name_suffix}"
  location                       = "europe-north1"
  service_class                  = "gcp-memorystore"
  description                    = "my basic service connection policy"
  network                        = google_compute_network.secondary_producer_net.id
  psc_config {                 
    subnetworks                  = [google_compute_subnetwork.secondary_producer_subnet.id]
  }
}

resource "google_compute_subnetwork" "secondary_producer_subnet" {
  name                           = "my-subnet-secondary-instance-${local.name_suffix}"
  ip_cidr_range                  = "10.0.2.0/29"
  region                         = "europe-north1"
  network                        = google_compute_network.secondary_producer_net.id
}

resource "google_compute_network" "secondary_producer_net" {
  name                           =  "my-network-secondary-instance-${local.name_suffix}"
  auto_create_subnetworks        = false
}

data "google_project" "project" {
}
