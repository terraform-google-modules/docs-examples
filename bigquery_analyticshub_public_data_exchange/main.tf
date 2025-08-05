resource "google_bigquery_analytics_hub_data_exchange" "data_exchange" {
  location         = "US"
  data_exchange_id = "public_data_exchange-${local.name_suffix}"
  display_name     = "public_data_exchange-${local.name_suffix}"
  description      = "Example for public data exchange-${local.name_suffix}"
  discovery_type   = "DISCOVERY_TYPE_PUBLIC"
}
