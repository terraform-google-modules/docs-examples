resource "google_bigquery_analytics_hub_data_exchange" "subscription" {
  location         = "US"
  data_exchange_id = "my_data_exchange-${local.name_suffix}"
  display_name     = "my_data_exchange-${local.name_suffix}"
  description      = ""
}

resource "google_bigquery_analytics_hub_listing" "subscription" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.subscription.data_exchange_id
  listing_id       = "my_listing-${local.name_suffix}"
  display_name     = "my_listing-${local.name_suffix}"
  description      = ""

  bigquery_dataset {
    dataset = google_bigquery_dataset.subscription.id
  }
}

resource "google_bigquery_dataset" "subscription" {
  dataset_id                  = "my_listing-${local.name_suffix}"
  friendly_name               = "my_listing-${local.name_suffix}"
  description                 = ""
  location                    = "US"
}

resource "google_bigquery_analytics_hub_listing_subscription" "subscription" {
  location = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.subscription.data_exchange_id
  listing_id       = google_bigquery_analytics_hub_listing.subscription.listing_id
  destination_dataset {
    description = "A test subscription"
    friendly_name = "👋"
    labels = {
      testing = "123"
    }
    location = "US"
    dataset_reference {
      dataset_id = "destination_dataset-${local.name_suffix}"
      project_id = google_bigquery_dataset.subscription.project
    }
  }
}
