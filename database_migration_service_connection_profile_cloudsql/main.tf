data "google_project" "project" {
}

resource "google_sql_database_instance" "cloudsqldb" {
  name             = "my-database-${local.name_suffix}"
  database_version = "MYSQL_5_7"
  settings {
    tier = "db-n1-standard-1"
    deletion_protection_enabled = false
  }
  deletion_protection = false
}

resource "google_sql_ssl_cert" "sql_client_cert" {
  common_name = "my-cert-${local.name_suffix}"
  instance    = google_sql_database_instance.cloudsqldb.name
  
  depends_on = [google_sql_database_instance.cloudsqldb]
}

resource "google_sql_user" "sqldb_user" {
  name     = "my-username-${local.name_suffix}"
  instance = google_sql_database_instance.cloudsqldb.name
  password = "my-password-${local.name_suffix}"
  
  depends_on = [google_sql_ssl_cert.sql_client_cert]
}



resource "google_database_migration_service_connection_profile" "cloudsqlprofile" {
  location              = "us-central1"
  connection_profile_id = "my-fromprofileid-${local.name_suffix}"
  display_name          = "my-fromprofileid-${local.name_suffix}_display"
  labels = { 
    foo = "bar"
  }
  mysql {
    host     = google_sql_database_instance.cloudsqldb.ip_address.0.ip_address
    port     = 3306
    username = google_sql_user.sqldb_user.name
    password = google_sql_user.sqldb_user.password
    ssl {
      client_key         = google_sql_ssl_cert.sql_client_cert.private_key
      client_certificate = google_sql_ssl_cert.sql_client_cert.cert
      ca_certificate     = google_sql_ssl_cert.sql_client_cert.server_ca_cert
      type = "SERVER_CLIENT"
    }
    cloud_sql_id = "my-database-${local.name_suffix}"
  }

  depends_on = [google_sql_user.sqldb_user]
}


resource "google_database_migration_service_connection_profile" "cloudsqlprofile_destination" {
  location              = "us-central1"
  connection_profile_id = "my-toprofileid-${local.name_suffix}"
  display_name          = "my-toprofileid-${local.name_suffix}_displayname"
  labels = { 
    foo = "bar"
  }
  cloudsql {
    settings {
      database_version = "MYSQL_5_7"
      user_labels = { 
        cloudfoo = "cloudbar"
      }
      tier                      = "db-n1-standard-1"
      edition                   = "ENTERPRISE"
      storage_auto_resize_limit = "0"
      activation_policy         = "ALWAYS"
      ip_config {
        enable_ipv4 = true
        require_ssl = true
      }
      auto_storage_increase = true
      data_disk_type        = "PD_HDD"
      data_disk_size_gb     = "11"
      zone                  = "us-central1-b"
      source_id             = "projects/${data.google_project.project.project_id}/locations/us-central1/connectionProfiles/my-fromprofileid-${local.name_suffix}"
      root_password         = "testpasscloudsql"
    }
  }
  depends_on = [google_database_migration_service_connection_profile.cloudsqlprofile]
}
