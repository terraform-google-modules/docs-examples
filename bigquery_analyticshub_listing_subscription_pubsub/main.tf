resource "google_bigquery_analytics_hub_data_exchange" "subscription" {
  location         = "US"
  data_exchange_id = "my_data_exchange-${local.name_suffix}"
  display_name     = "my_data_exchange-${local.name_suffix}"
  description      = "example pubsub listing subscription-${local.name_suffix}"
}

resource "google_pubsub_topic" "subscription" {
  name = "my_pubsub_topic-${local.name_suffix}"
}

resource "google_bigquery_analytics_hub_listing" "subscription" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.subscription.data_exchange_id
  listing_id       = "my_listing-${local.name_suffix}"
  display_name     = "my_listing-${local.name_suffix}"
  description      = "example pubsub listing subscription-${local.name_suffix}"

  pubsub_topic {
    topic = google_pubsub_topic.subscription.id
  }
}

resource "google_bigquery_analytics_hub_listing_subscription" "subscription" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.subscription.data_exchange_id
  listing_id       = google_bigquery_analytics_hub_listing.subscription.listing_id

  destination_pubsub_subscription {
    pubsub_subscription {
      name = "projects/${google_pubsub_topic.subscription.project}/subscriptions/my_pubsub_subscription-${local.name_suffix}"
    }
  }
}
