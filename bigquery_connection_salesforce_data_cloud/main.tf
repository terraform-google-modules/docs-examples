resource "google_bigquery_connection" "connection" {
  connection_id = "my-connection-${local.name_suffix}"
  location      = "US"

  salesforce_data_cloud {
    instance_uri = "my-instance.c360a.salesforce.com"
    tenant_id    = "tenant-id"
  }
}
