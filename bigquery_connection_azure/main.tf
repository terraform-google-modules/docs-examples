resource "google_bigquery_connection" "connection" {
   connection_id = "my-connection-${local.name_suffix}"
   location      = "azure-eastus2"
   friendly_name = "👋"
   description   = "a riveting description"
   azure {
      customer_tenant_id = "customer-tenant-id-${local.name_suffix}"
      federated_application_client_id = "b43eeeee-eeee-eeee-eeee-a480155501ce-${local.name_suffix}"
   }
}
