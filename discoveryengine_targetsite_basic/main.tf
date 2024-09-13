resource "google_discovery_engine_target_site" "basic" {
  location                    = google_discovery_engine_data_store.basic.location
  data_store_id               = google_discovery_engine_data_store.basic.data_store_id
  provided_uri_pattern        = "http://cloud.google.com/docs/*"
  type                        = "INCLUDE"
  exact_match                 = false
}

resource "google_discovery_engine_data_store" "basic" {
  location                     = "global"
  data_store_id                = "data-store-id-${local.name_suffix}"
  display_name                 = "tf-test-basic-site-search-datastore"
  industry_vertical            = "GENERIC"
  content_config               = "PUBLIC_WEBSITE"
  solution_types               = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search  = false
  skip_default_schema_creation = false
}