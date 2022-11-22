resource "google_sql_database" "database_deletion_policy" {
  name     = "my-database-${local.name_suffix}"
  instance = google_sql_database_instance.instance.name
  deletion_policy = "ABANDON"
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "my-database-instance-${local.name_suffix}"
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-g1-small"
  }

  deletion_protection  = "false"
}
