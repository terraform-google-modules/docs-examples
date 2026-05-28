resource "google_oracle_database_goldengate_connection" "connection" {
  goldengate_connection_id = "my-connection-${local.name_suffix}"
  location                 = "us-east4"
  project                  = "my-project-${local.name_suffix}"
  gcp_oracle_zone          = "us-east4-b-r1"

  properties {
    display_name    = "my-connection-${local.name_suffix} display name"
    connection_type = "POSTGRESQL"
    postgresql_connection_properties {
      technology_type   = "POSTGRESQL_SERVER"
      database          = "postgres_app_db"
      host              = "postgres.corp.example.com"
      port              = 5432
      username          = "pg_replicator"
      password          = "PostgresReplicationP@ssw0rd!"
      security_protocol = "PLAIN"
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}
