resource "google_alloydb_backup" "default" {
  location     = "us-central1"
  backup_id    = "alloydb-backup-${local.name_suffix}"
  cluster_name = google_alloydb_cluster.default.name

  description = "example description"
  type = "ON_DEMAND"
  labels = {
    "label" = "key"
  }
  depends_on = [google_alloydb_instance.default]
}

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = data.google_compute_network.default.id
  }
}

resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance-${local.name_suffix}"
  instance_type = "PRIMARY"
}

data "google_compute_network" "default" {
  name = "alloydb-network-${local.name_suffix}"
}
