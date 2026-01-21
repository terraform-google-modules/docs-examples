resource "google_oracle_database_autonomous_database" "myADB"{
  autonomous_database_id = "my-primary-adb-id-${local.name_suffix}"
  location = "my-location-${local.name_suffix}"
  project = "my-project-${local.name_suffix}"
  source_config {
    autonomous_database = ""projects/my-project/locations/us-east4/autonomousDatabases/adb-id"-${local.name_suffix}"
    automatic_backups_replication_enabled = "false-${local.name_suffix}"
    }
  deletion_protection = "true-${local.name_suffix}"
}
