resource "google_bigquery_analytics_hub_data_exchange" "data_exchange" {
  location         = "US"
  data_exchange_id = "tf_test_log_email_data_exchange-${local.name_suffix}" 
  display_name     = "tf_test_log_email_data_exchange-${local.name_suffix}" 
  description      = "Example for log email test for data exchange-${local.name_suffix}"
  log_linked_dataset_query_user_email = true
}
