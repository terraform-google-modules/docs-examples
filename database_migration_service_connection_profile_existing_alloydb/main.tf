data "google_project" "project" {
}

resource "google_alloydb_cluster" "destination_alloydb" {
  cluster_id = "destination-alloydb-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = data.google_compute_network.default.id
  }
  database_version = "POSTGRES_15"

  initial_user {
    user     = "destination-alloydb-${local.name_suffix}"
    password = "destination-alloydb-${local.name_suffix}"
  }

  deletion_protection = false
}

resource "google_alloydb_instance" "destination_alloydb_primary" {
  cluster       = google_alloydb_cluster.destination_alloydb.name
  instance_id   = "destination-alloydb-${local.name_suffix}-primary"
  instance_type = "PRIMARY"
}

data "google_compute_network" "default" {
  name = "destination-alloydb-${local.name_suffix}"
}

resource "google_database_migration_service_connection_profile" "existing-alloydb" {
  location              = "us-central1"
  connection_profile_id = "destination-cp-${local.name_suffix}"
  display_name          = "destination-cp-${local.name_suffix}-display"
  labels = {
    foo = "bar"
  }
  postgresql {
    alloydb_cluster_id = "destination-alloydb-${local.name_suffix}"
  }
  depends_on = [google_alloydb_cluster.destination_alloydb, google_alloydb_instance.destination_alloydb_primary]
}
