resource "google_oracle_database_goldengate_connection" "connection" {
  goldengate_connection_id = "my-connection-${local.name_suffix}"
  location                 = "asia-south1"
  project                  = "my-project-${local.name_suffix}"
  gcp_oracle_zone          = "asia-south1-b-r1"


  properties {
    display_name    = "my-connection-${local.name_suffix} display name"
    connection_type = "ORACLE"
    oracle_connection_properties {
      technology_type   = "ORACLE_AUTONOMOUS_DATABASE_AT_GOOGLE_CLOUD"
      connection_string = "jdbc:oracle:thin:@//10.0.0.5:1521/ORCL"
      username          = "admin"
      password          = "GenerateWallet@123"
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}
