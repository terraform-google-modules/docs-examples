resource "google_oracle_database_goldengate_connection" "connection" {
  goldengate_connection_id = "my-connection-${local.name_suffix}"
  location                 = "europe-west3"
  project                  = "my-project-${local.name_suffix}"
  gcp_oracle_zone          = "europe-west3-b-r1"

  properties {
    display_name    = "my-connection-${local.name_suffix} display name"
    connection_type = "SNOWFLAKE"
    snowflake_connection_properties {
      technology_type     = "SNOWFLAKE"
      connection_url      = "jdbc:snowflake://xy12345.snowflakecomputing.com/?warehouse=COMPUTE_WH&db=ANALYTICS_DB"
      authentication_type = "BASIC"
      username            = "snowflake_sync_user"
      password            = "SnowflakeBasicP@ssword123!"
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}
