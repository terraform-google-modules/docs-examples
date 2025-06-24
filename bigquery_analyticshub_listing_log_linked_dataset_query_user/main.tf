resource "google_bigquery_analytics_hub_data_exchange" "listing_log_email" {
  location         = "US"
  data_exchange_id = "tf_test_log_email_de-${local.name_suffix}" 
  display_name     = "tf_test_log_email_de-${local.name_suffix}" 
  description      = "Example for log email test-${local.name_suffix}"
}

resource "google_bigquery_analytics_hub_listing" "listing" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.listing_log_email.data_exchange_id
  listing_id       = "tf_test_log_email_listing-${local.name_suffix}" 
  display_name     = "tf_test_log_email_listing-${local.name_suffix}" 
  description      = "Example for log email test-${local.name_suffix}"
  log_linked_dataset_query_user_email = true

  bigquery_dataset {
    dataset = google_bigquery_dataset.listing_log_email.id
  }
}

resource "google_bigquery_dataset" "listing_log_email" {
  dataset_id                  = "tf_test_log_email_ds-${local.name_suffix}" 
  friendly_name               = "tf_test_log_email_ds-${local.name_suffix}" 
  description                 = "Example for log email test-${local.name_suffix}"
  location                    = "US"
}
