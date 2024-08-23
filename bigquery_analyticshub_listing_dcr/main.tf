resource "google_bigquery_analytics_hub_data_exchange" "listing" {
  location         = "US"
  data_exchange_id = "dcr_data_exchange-${local.name_suffix}"
  display_name     = "dcr_data_exchange-${local.name_suffix}"
  description      = "example dcr data exchange-${local.name_suffix}"
  sharing_environment_config  {
    dcr_exchange_config {}
  }
}

resource "google_bigquery_analytics_hub_listing" "listing" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.listing.data_exchange_id
  listing_id       = "dcr_listing-${local.name_suffix}"
  display_name     = "dcr_listing-${local.name_suffix}"
  description      = "example dcr data exchange-${local.name_suffix}"

  bigquery_dataset {
    dataset = google_bigquery_dataset.listing.id
    selected_resources {
        table = google_bigquery_table.listing.id
    }
  }

  restricted_export_config {
    enabled                   = true
  }
}

resource "google_bigquery_dataset" "listing" {
  dataset_id                  = "dcr_listing-${local.name_suffix}"
  friendly_name               = "dcr_listing-${local.name_suffix}"
  description                 = "example dcr data exchange-${local.name_suffix}"
  location                    = "US"
}

resource "google_bigquery_table" "listing" {
  deletion_protection = false
  table_id   = "dcr_listing-${local.name_suffix}"
  dataset_id = google_bigquery_dataset.listing.dataset_id
  schema = <<EOF
[
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "post_abbr",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}
