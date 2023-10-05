resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance-${local.name_suffix}"
  instance_type = "PRIMARY"

  depends_on = [google_service_networking_connection.vpc_connection]
}

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network    = google_compute_network.default.id

  initial_user {
    password = "cluster_secret-${local.name_suffix}"
  }
}

data "google_project" "project" {}

resource "google_compute_network" "default" {
  name = "alloydb-network-${local.name_suffix}"
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "alloydb-cluster-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "google_alloydb_user" "user1" {
  cluster = google_alloydb_cluster.default.name
  user_id = "user1-${local.name_suffix}"
  user_type = "ALLOYDB_BUILT_IN"

  password = "user_secret-${local.name_suffix}"
  database_roles = ["alloydbsuperuser"]
  depends_on = [google_alloydb_instance.default]
}
