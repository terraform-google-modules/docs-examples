resource "google_discovery_engine_target_site" "advanced" {
  location                    = google_discovery_engine_data_store.advanced.location
  data_store_id               = google_discovery_engine_data_store.advanced.data_store_id
  provided_uri_pattern        = "cloud.google.com/docs/*"
  type                        = "INCLUDE"
  exact_match                 = false
}

resource "google_discovery_engine_data_store" "advanced" {
  location                     = "global"
  data_store_id                = "data-store-id-${local.name_suffix}"
  display_name                 = "tf-test-advanced-site-search-datastore"
  industry_vertical            = "GENERIC"
  content_config               = "PUBLIC_WEBSITE"
  solution_types               = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search  = true
  skip_default_schema_creation = false
}
