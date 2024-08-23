resource "google_bigquery_analytics_hub_data_exchange" "data_exchange" {
  location         = "US"
  data_exchange_id = "dcr_data_exchange-${local.name_suffix}"
  display_name     = "dcr_data_exchange-${local.name_suffix}"
  description      = "example dcr data exchange-${local.name_suffix}"
  sharing_environment_config  {
    dcr_exchange_config {}
  }
}
