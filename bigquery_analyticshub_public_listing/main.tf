resource "google_bigquery_analytics_hub_data_exchange" "listing" {
  location         = "US"
  data_exchange_id = "my_data_exchange-${local.name_suffix}"
  display_name     = "my_data_exchange-${local.name_suffix}"
  description      = "example public listing-${local.name_suffix}"
  discovery_type   = "DISCOVERY_TYPE_PUBLIC"
}

resource "google_bigquery_analytics_hub_listing" "listing" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.listing.data_exchange_id
  listing_id       = "my_listing-${local.name_suffix}"
  display_name     = "my_listing-${local.name_suffix}"
  description      = "example public listing-${local.name_suffix}"
  discovery_type   = "DISCOVERY_TYPE_PUBLIC"
  allow_only_metadata_sharing= false

  bigquery_dataset {
    dataset = google_bigquery_dataset.listing.id
  }
}

resource "google_bigquery_dataset" "listing" {
  dataset_id                  = "my_listing-${local.name_suffix}"
  friendly_name               = "my_listing-${local.name_suffix}"
  description                 = "example public listing-${local.name_suffix}"
  location                    = "US"
}
