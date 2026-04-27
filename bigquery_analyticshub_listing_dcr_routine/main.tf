resource "google_bigquery_analytics_hub_data_exchange" "dcr_data_exchange_example" {
  location         = "us"
  data_exchange_id = "tf_test_data_exchange-${local.name_suffix}"
  display_name     = "tf_test_data_exchange-${local.name_suffix}"
  description      = "Example for listing with routine-${local.name_suffix}"
  sharing_environment_config {
    dcr_exchange_config {}
  }
}

resource "google_bigquery_dataset" "listing" {
  dataset_id    = "tf_test_dataset-${local.name_suffix}"
  friendly_name = "tf_test_dataset-${local.name_suffix}"
  description   = "Example for listing with routine-${local.name_suffix}"
  location      = "us"
}

resource "google_bigquery_routine" "listing" {
  dataset_id      = google_bigquery_dataset.listing.dataset_id
  routine_id      = "tf_test_routine-${local.name_suffix}"
  routine_type    = "TABLE_VALUED_FUNCTION"
  language        = "SQL"
  description     = "A DCR routine example."
  definition_body = <<-EOS
    SELECT 1 + value AS value
  EOS
  arguments {
    name          = "value"
    argument_kind = "FIXED_TYPE"
    data_type     = jsonencode({ "typeKind" : "INT64" })
  }
  return_table_type = jsonencode({
    "columns" : [
      { "name" : "value", "type" : { "typeKind" : "INT64" } },
    ]
  })
}

resource "google_bigquery_analytics_hub_listing" "listing" {
  location         = "US"
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.dcr_data_exchange_example.data_exchange_id
  listing_id       = "tf_test_listing_routine-${local.name_suffix}"
  display_name     = "tf_test_listing_routine-${local.name_suffix}"
  description      = "Example for listing with routine-${local.name_suffix}"
  bigquery_dataset {
    dataset = google_bigquery_dataset.listing.id
    selected_resources {
      routine = google_bigquery_routine.listing.id
    }
  }
  restricted_export_config {
    enabled = true
  }
}
