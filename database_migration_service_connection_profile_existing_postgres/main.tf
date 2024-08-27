data "google_project" "project" {
}

resource "google_sql_database_instance" "destination_csql" {
  name             = "destination-csql-${local.name_suffix}"
  database_version = "POSTGRES_15"
  settings {
    tier = "db-custom-2-13312"
    deletion_protection_enabled = false
  }
  deletion_protection = false
}

resource "google_database_migration_service_connection_profile" "existing-psql" {
  location              = "us-central1"
  connection_profile_id = "destination-cp-${local.name_suffix}"
  display_name          = "destination-cp-${local.name_suffix}_display"
  labels = {
    foo = "bar"
  }
  postgresql {
    cloud_sql_id = "destination-csql-${local.name_suffix}"
  }
  depends_on = [google_sql_database_instance.destination_csql]
}
