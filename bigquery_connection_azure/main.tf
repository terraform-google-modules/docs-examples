resource "google_bigquery_connection" "connection" {
   connection_id = "my-connection-${local.name_suffix}"
   location      = "azure-eastus2"
   friendly_name = "👋"
   description   = "a riveting description"
   azure {
      customer_tenant_id = "customer-tenant-id-${local.name_suffix}"
   }
}
