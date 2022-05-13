resource "google_bigquery_connection" "connection" {
   connection_id = "my-connection-${local.name_suffix}"
   location      = "US"
   friendly_name = "👋"
   description   = "a riveting description"
   cloud_resource {}
}
