resource "google_oracle_database_autonomous_database" "adb-dr"{
  autonomous_database_id = "my-instance-${local.name_suffix}"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  database = "mydatabase-${local.name_suffix}"
  admin_password = "123Abpassword"
  properties {
    compute_count = "2"
    data_storage_size_gb="20"
    db_version = "19c"
    db_workload = "OLTP"
    license_type = "LICENSE_INCLUDED"
    mtls_connection_required = "true"
    }
  deletion_protection = "true-${local.name_suffix}"
}


resource "google_oracle_database_autonomous_database" "myADB"{
  autonomous_database_id = "my-instance-${local.name_suffix}"
  location = "my-location-${local.name_suffix}"
  project = "my-project-${local.name_suffix}"
  source_config {
    autonomous_database = google_oracle_database_autonomous_database.adb-dr.name
    automatic_backups_replication_enabled = "false-${local.name_suffix}"
    }
  deletion_protection = "true-${local.name_suffix}"
}
