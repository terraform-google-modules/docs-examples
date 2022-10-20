resource "google_bigquery_analytics_hub_data_exchange" "listing" {
  location         = "US"
  data_exchange_id = "my_data_exchange-${local.name_suffix}"
  display_name     = "my_data_exchange-${local.name_suffix}"
  description      = "example data exchange-${local.name_suffix}"
}

resource "google_bigquery_analytics_hub_listing" "listing" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.listing.data_exchange_id
  listing_id       = "my_listing-${local.name_suffix}"
  display_name     = "my_listing-${local.name_suffix}"
  description      = "example data exchange-${local.name_suffix}"

  bigquery_dataset {
    dataset = google_bigquery_dataset.listing.id
  }
}

resource "google_bigquery_dataset" "listing" {
  dataset_id                  = "my_listing-${local.name_suffix}"
  friendly_name               = "my_listing-${local.name_suffix}"
  description                 = "example data exchange-${local.name_suffix}"
  location                    = "US"
}
