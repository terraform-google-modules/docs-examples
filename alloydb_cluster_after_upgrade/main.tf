resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance-${local.name_suffix}"
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = 2
  }

}

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = data.google_compute_network.default.id
  }
  database_version = "POSTGRES_15"

  initial_user {
    password = "alloydb-cluster-${local.name_suffix}"
  }

  deletion_protection = false
}

data "google_compute_network" "default" {
  name = "alloydb-network-${local.name_suffix}"
}
