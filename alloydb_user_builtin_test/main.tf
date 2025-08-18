resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = "alloydb-instance-${local.name_suffix}"
  instance_type = "PRIMARY"
}

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-cluster-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = data.google_compute_network.default.id
  }
  initial_user {
    password = "cluster_secret-${local.name_suffix}"
  }

  deletion_protection = false
}

data "google_project" "project" {}

data "google_compute_network" "default" {
  name = "alloydb-network-${local.name_suffix}"
}


resource "google_alloydb_user" "user1" {
  cluster = google_alloydb_cluster.default.name
  user_id = "user1-${local.name_suffix}"
  user_type = "ALLOYDB_BUILT_IN"

  password = "user_secret-${local.name_suffix}"
  database_roles = ["alloydbsuperuser"]
  depends_on = [google_alloydb_instance.default]
}
