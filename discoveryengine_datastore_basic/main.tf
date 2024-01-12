resource "google_discovery_engine_data_store" "basic" {
  location                    = "global"
  data_store_id               = "data-store-id-${local.name_suffix}"
  display_name                = "tf-test-structured-datastore"
  industry_vertical           = "GENERIC"
  content_config              = "NO_CONTENT"
  solution_types              = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search = false
}
