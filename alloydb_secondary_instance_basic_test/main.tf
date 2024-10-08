resource "google_alloydb_cluster" "primary" {
  cluster_id = "alloydb-primary-cluster-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = data.google_compute_network.default.id
  }
}

resource "google_alloydb_instance" "primary" {
  cluster       = google_alloydb_cluster.primary.name
  instance_id   = "alloydb-primary-instance-${local.name_suffix}"
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = 2
  }
}

resource "google_alloydb_cluster" "secondary" {
  cluster_id   = "alloydb-secondary-cluster-${local.name_suffix}"
  location     = "us-east1"
  network_config {
    network = data.google_compute_network.default.id
  }
  cluster_type = "SECONDARY"

  continuous_backup_config {
    enabled = false
  }

  secondary_config {
    primary_cluster_name = google_alloydb_cluster.primary.name
  }

  deletion_policy = "FORCE"

  depends_on = [google_alloydb_instance.primary]
}

resource "google_alloydb_instance" "secondary" {
  cluster       = google_alloydb_cluster.secondary.name
  instance_id   = "alloydb-secondary-instance-${local.name_suffix}"
  instance_type = google_alloydb_cluster.secondary.cluster_type

  machine_config {
    cpu_count = 2
  }
}

data "google_project" "project" {}

data "google_compute_network" "default" {
  name = "alloydb-secondary-network-${local.name_suffix}"
}
