resource "google_bigquery_connection" "connection" {
   connection_id = "my-connection-${local.name_suffix}"
   location      = "US"
   friendly_name = "👋"
   description   = "a riveting description"
   cloud_spanner { 
      database                 = "projects/project/instances/instance/databases/database-${local.name_suffix}"
      use_serverless_analytics = true
      use_parallelism          = true
   }
}
