resource "google_bigquery_connection" "connection" {
  connection_id = "my-connection-${local.name_suffix}"
  location      = "US"

  salesforce_data_cloud {
    instance_uri = "https://updated-instance.my.salesforce.com"
    tenant_id    = "updated-tenant-id"

    cross_cloud_cache_options {
      enabled = true
    }
  }
}
