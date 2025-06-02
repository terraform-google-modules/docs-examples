resource "google_bigquery_dataset" "dataset" {
  dataset_id    = "example_dataset-${local.name_suffix}"
  friendly_name = "test"
  description   = "This is a test description"
  location      = "US"

  external_catalog_dataset_options {
    parameters = {
      "dataset_owner" = "test_dataset_owner"
    }
    default_storage_location_uri = "gs://test_dataset/tables"
  }
}
