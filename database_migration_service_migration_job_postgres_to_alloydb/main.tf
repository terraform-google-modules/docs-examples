data "google_project" "project" {
}

resource "google_sql_database_instance" "source_csql" {
  name             = "source-csql-${local.name_suffix}"
  database_version = "POSTGRES_15"
  settings {
    tier = "db-custom-2-13312"
    deletion_protection_enabled = false
  }
  deletion_protection = false
}

resource "google_sql_ssl_cert" "source_sql_client_cert" {
  common_name = "cert-${local.name_suffix}"
  instance    = google_sql_database_instance.source_csql.name

  depends_on = [google_sql_database_instance.source_csql]
}

resource "google_sql_user" "source_sqldb_user" {
  name     = "username-${local.name_suffix}"
  instance = google_sql_database_instance.source_csql.name
  password = "password-${local.name_suffix}"

  depends_on = [google_sql_ssl_cert.source_sql_client_cert]
}

resource "google_database_migration_service_connection_profile" "source_cp" {
  location              = "us-central1"
  connection_profile_id = "source-cp-${local.name_suffix}"
  display_name          = "source-cp-${local.name_suffix}_display"
  labels = {
    foo = "bar"
  }
  postgresql {
    host     = google_sql_database_instance.source_csql.ip_address.0.ip_address
    port     = 3306
    username = google_sql_user.source_sqldb_user.name
    password = google_sql_user.source_sqldb_user.password
    ssl {
      client_key         = google_sql_ssl_cert.source_sql_client_cert.private_key
      client_certificate = google_sql_ssl_cert.source_sql_client_cert.cert
      ca_certificate     = google_sql_ssl_cert.source_sql_client_cert.server_ca_cert
      type = "SERVER_CLIENT"
    }
    cloud_sql_id = "source-csql-${local.name_suffix}"
  }

  depends_on = [google_sql_user.source_sqldb_user]
}

resource "google_alloydb_cluster" "destination_alloydb" {
  cluster_id = "destination-alloydb-${local.name_suffix}"
  location   = "us-central1"
  network_config {
    network = google_compute_network.default.id
  }
  database_version = "POSTGRES_15"

  initial_user {
    user     = "destination-alloydb-${local.name_suffix}"
    password = "destination-alloydb-${local.name_suffix}"
  }
}

resource "google_alloydb_instance" "destination_alloydb_primary" {
  cluster       = google_alloydb_cluster.destination_alloydb.name
  instance_id   = "destination-alloydb-${local.name_suffix}-primary"
  instance_type = "PRIMARY"

  depends_on = [google_service_networking_connection.vpc_connection]
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          =  "destination-alloydb-${local.name_suffix}"
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

resource "google_compute_network" "default" {
  name = "destination-alloydb-${local.name_suffix}"
}

resource "google_database_migration_service_connection_profile" "destination_cp" {
  location              = "us-central1"
  connection_profile_id = "destination-cp-${local.name_suffix}"
  display_name          = "destination-cp-${local.name_suffix}_display"
  labels = {
    foo = "bar"
  }
  postgresql {
    alloydb_cluster_id = "destination-alloydb-${local.name_suffix}"
  }
  depends_on = [google_alloydb_cluster.destination_alloydb, google_alloydb_instance.destination_alloydb_primary]
}

resource "google_database_migration_service_migration_job" "psqltoalloydb" {
  location              = "us-central1"
  migration_job_id = "my-migrationid-${local.name_suffix}"
  display_name = "my-migrationid-${local.name_suffix}_display"
  labels = {
    foo = "bar"
  }
  static_ip_connectivity {
  }
  source          = google_database_migration_service_connection_profile.source_cp.name
  destination     = google_database_migration_service_connection_profile.destination_cp.name
  type            = "CONTINUOUS"
}


