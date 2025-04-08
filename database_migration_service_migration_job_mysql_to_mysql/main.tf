data "google_project" "project" {
}

resource "google_sql_database_instance" "source_csql" {
  name             = "source-csql-${local.name_suffix}"
  database_version = "MYSQL_5_7"
  settings {
    tier = "db-n1-standard-1"
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
  mysql {
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

resource "google_sql_database_instance" "destination_csql" {
  name             = "destination-csql-${local.name_suffix}"
  database_version = "MYSQL_5_7"
  settings {
    tier = "db-n1-standard-1"
    deletion_protection_enabled = false
  }
  deletion_protection = false
}

resource "google_database_migration_service_connection_profile" "destination_cp" {
  location              = "us-central1"
  connection_profile_id = "destination-cp-${local.name_suffix}"
  display_name          = "destination-cp-${local.name_suffix}_display"
  labels = {
    foo = "bar"
  }
  mysql {
    cloud_sql_id = "destination-csql-${local.name_suffix}"
  }
  depends_on = [google_sql_database_instance.destination_csql]
}

resource "google_compute_network" "default" {
  name = "destination-csql-${local.name_suffix}"
}

resource "google_database_migration_service_migration_job" "mysqltomysql" {
  location              = "us-central1"
  migration_job_id = "my-migrationid-${local.name_suffix}"
  display_name = "my-migrationid-${local.name_suffix}_display"
  labels = {
    foo = "bar"
  }
  performance_config {
    dump_parallel_level = "MAX"
  }
  vpc_peering_connectivity {
    vpc = google_compute_network.default.id
  }
  dump_type = "LOGICAL"
  dump_flags {
    dump_flags {
      name = "max-allowed-packet"
      value = "1073741824"
    }
  }
  source          = google_database_migration_service_connection_profile.source_cp.name
  destination     = google_database_migration_service_connection_profile.destination_cp.name
  type            = "CONTINUOUS"
}


