data "google_project" "project" {
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

resource "google_database_migration_service_connection_profile" "existing-mysql" {
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
