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

  initial_user {
    password = "alloydb-cluster-${local.name_suffix}"
  }
  psc_config {
    psc_enabled = true
  }

  deletion_protection = false
}
