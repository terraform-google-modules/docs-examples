resource "google_sql_database_instance" "postgresqldb" {
  name             = "my-database-${local.name_suffix}"
  database_version = "POSTGRES_12"
  settings {
    tier = "db-custom-2-13312"
  }
  deletion_protection = false
}

resource "google_sql_ssl_cert" "sql_client_cert" {
  common_name = "my-cert-${local.name_suffix}"
  instance    = google_sql_database_instance.postgresqldb.name

  depends_on = [google_sql_database_instance.postgresqldb]
}

resource "google_sql_user" "sqldb_user" {
  name     = "my-username-${local.name_suffix}"
  instance = google_sql_database_instance.postgresqldb.name
  password = "my-password-${local.name_suffix}"


  depends_on = [google_sql_ssl_cert.sql_client_cert]
}

resource "google_database_migration_service_connection_profile" "postgresprofile" {
  location = "us-central1"
  connection_profile_id = "my-profileid-${local.name_suffix}"
  display_name = "my-profileid-${local.name_suffix}_display"
  labels = { 
    foo = "bar" 
  }
  postgresql {
    host = google_sql_database_instance.postgresqldb.ip_address.0.ip_address
    port = 5432
    username = google_sql_user.sqldb_user.name
    password = google_sql_user.sqldb_user.password
    ssl {
      client_key = google_sql_ssl_cert.sql_client_cert.private_key
      client_certificate = google_sql_ssl_cert.sql_client_cert.cert
      ca_certificate = google_sql_ssl_cert.sql_client_cert.server_ca_cert
    }
    cloud_sql_id = "my-database-${local.name_suffix}"
  }
  depends_on = [google_sql_user.sqldb_user]
}
