resource "google_oracle_database_goldengate_connection" "connection" {
  goldengate_connection_id = "my-connection-${local.name_suffix}"
  location                 = "us-east4"
  project                  = "my-project-${local.name_suffix}"
  odb_network              = "projects/my-project/locations/us-east4/odbNetworks/my-network-${local.name_suffix}"
  odb_subnet               = "projects/my-project/locations/us-east4/odbNetworks/my-network/odbSubnets/my-subnet-${local.name_suffix}"
  gcp_oracle_zone          = "us-east4-b-r1"
  labels = {
    "label-one" = "value-one"
  }

  properties {
    display_name    = "my-connection-${local.name_suffix} display name"
    connection_type = "ORACLE"
    routing_method  = "DEDICATED_ENDPOINT"
    oracle_connection_properties {
      technology_type        = "ORACLE_AUTONOMOUS_DATABASE_AT_GOOGLE_CLOUD"
      username               = "admin"
      password               = "GenerateWallet@123"
      session_mode           = "DIRECT"
      gcp_oracle_database_id = "projects/my-project-${local.name_suffix}/locations/us-east4/autonomousDatabases/my-autonomous-database-${local.name_suffix}"
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}
