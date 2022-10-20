resource "google_bigquery_analytics_hub_data_exchange" "data_exchange" {
  location         = "US"
  data_exchange_id = "my_data_exchange-${local.name_suffix}"
  display_name     = "my_data_exchange-${local.name_suffix}"
  description      = "example data exchange-${local.name_suffix}"
}
