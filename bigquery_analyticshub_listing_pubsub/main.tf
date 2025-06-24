resource "google_bigquery_analytics_hub_data_exchange" "listing" {
  location         = "US"
  data_exchange_id = "tf_test_pubsub_data_exchange-${local.name_suffix}"
  display_name     = "tf_test_pubsub_data_exchange-${local.name_suffix}"
  description      = "Example for pubsub topic source-${local.name_suffix}"
}

resource "google_pubsub_topic" "tf_test_pubsub_topic" { 
  name    = "test_pubsub-${local.name_suffix}" 
}

resource "google_bigquery_analytics_hub_listing" "listing" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.listing.data_exchange_id
  listing_id       = "tf_test_pubsub_listing-${local.name_suffix}"
  display_name     = "tf_test_pubsub_listing-${local.name_suffix}"
  description      = "Example for pubsub topic source-${local.name_suffix}"

  pubsub_topic {
    topic = google_pubsub_topic.tf_test_pubsub_topic.id
    data_affinity_regions = [
      "us-central1",
      "europe-west1"
    ]
  }
}
