resource "google_discovery_engine_data_store" "basic" {
  location                    = "global"
  data_store_id               = "example-datastore-id-${local.name_suffix}"
  display_name                = "tf-test-structured-datastore"
  industry_vertical           = "GENERIC"
  content_config              = "NO_CONTENT"
  solution_types              = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search = false
}
resource "google_discovery_engine_search_engine" "basic" {
  engine_id = "example-engine-id-${local.name_suffix}"
  collection_id = "default_collection"
  location = google_discovery_engine_data_store.basic.location
  display_name = "Example Display Name"
  data_store_ids = [google_discovery_engine_data_store.basic.data_store_id]
  search_engine_config {
  }
}
