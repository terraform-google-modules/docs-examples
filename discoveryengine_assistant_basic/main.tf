resource "google_discovery_engine_data_store" "basic" {
  location                      = "global"
  data_store_id                 = "example-data-store-id-${local.name_suffix}"
  display_name                  = "tf-test-structured-datastore"
  industry_vertical             = "GENERIC"
  content_config                = "NO_CONTENT"
  solution_types                = ["SOLUTION_TYPE_SEARCH"]
  create_advanced_site_search   = false
}
resource "google_discovery_engine_search_engine" "basic" {
  location                      = "global"
  collection_id                 = "default_collection"
  engine_id                     = "example-engine-id-${local.name_suffix}"
  display_name                  = "Example Display Name"
  data_store_ids                = [google_discovery_engine_data_store.basic.data_store_id]
  search_engine_config {
  }
}
resource "google_discovery_engine_assistant" "basic" {
  location                      = "global"
  collection_id                 = "default_collection"
  engine_id                     = google_discovery_engine_search_engine.basic.engine_id
  assistant_id                  = "example-assistant-id-${local.name_suffix}"
  display_name                  = "updated-tf-test-Assistant"
  description                   = "Assistant Description"
  generation_config {
    system_instruction {
      additional_system_instruction = "foobar"
    }
    default_language            = "en"
  }
  customer_policy {
    banned_phrases {
      phrase                    = "foo"
      match_type                = "SIMPLE_STRING_MATCH"
      ignore_diacritics         = false
    }
  }
  web_grounding_type            = "WEB_GROUNDING_TYPE_GOOGLE_SEARCH"
}
