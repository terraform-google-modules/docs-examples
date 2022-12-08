resource "google_alloydb_backup" "default" {
  provider     = google-beta
  location     = "us-central1"
  backup_id    = "alloydb-backup-${local.name_suffix}"
  cluster_name = google_alloydb_cluster.default.name

  description = "example description"
  labels = {
    "label" = "key"
  }
  depends_on = [google_alloydb_instance.default]
}

resource "google_alloydb_cluster" "default" {
  provider   = google-beta
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network    = data.google_compute_network.default.id
}

resource "google_alloydb_instance" "default" {
  provider      = google-beta
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance-${local.name_suffix}"
  instance_type = "PRIMARY"

  depends_on = [google_service_networking_connection.vpc_connection]
}

resource "google_compute_global_address" "private_ip_alloc" {
  provider = google-beta
  name          =  "alloydb-cluster-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = data.google_compute_network.default.id
}

resource "google_service_networking_connection" "vpc_connection" {
  provider   = google-beta
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

data "google_compute_network" "default" {
  provider = google-beta
  name = "alloydb-network-${local.name_suffix}"
}
