resource "google_discovery_engine_data_store" "advanced_site_search_config" {
  location                     = "global"
  data_store_id                = "data-store-id-${local.name_suffix}"
  display_name                 = "tf-test-advanced-site-search-config-datastore"
  industry_vertical            = "GENERIC"
  content_config               = "PUBLIC_WEBSITE"
  solution_types               = ["SOLUTION_TYPE_CHAT"]
  create_advanced_site_search  = true
  skip_default_schema_creation = false

  advanced_site_search_config {
    disable_initial_index = true
    disable_automatic_refresh = true
  }
}
