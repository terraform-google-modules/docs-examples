resource "google_discovery_engine_data_store" "test_data_store" {
  location                    = "global"
  data_store_id               = "data-store-${local.name_suffix}"
  display_name                = "Structured datastore"
  industry_vertical           = "GENERIC"
  content_config              = "NO_CONTENT"
  solution_types              = ["SOLUTION_TYPE_CHAT"]
}

resource "google_discovery_engine_data_store" "test_data_store_2" {
  location                    = google_discovery_engine_data_store.test_data_store.location
  data_store_id               = "data-store-2-${local.name_suffix}"
  display_name                = "Structured datastore 2"
  industry_vertical           = "GENERIC"
  content_config              = "NO_CONTENT"
  solution_types              = ["SOLUTION_TYPE_CHAT"]
}

resource "google_discovery_engine_chat_engine" "primary" {
  engine_id = "chat-engine-id-${local.name_suffix}"
  collection_id = "default_collection"
  location = google_discovery_engine_data_store.test_data_store.location
  display_name = "Chat engine"
  industry_vertical = "GENERIC"
  data_store_ids = [google_discovery_engine_data_store.test_data_store.data_store_id, google_discovery_engine_data_store.test_data_store_2.data_store_id]
  common_config {
    company_name = "test-company"
  }
  chat_engine_config {
    agent_creation_config {
    business = "test business name"
    default_language_code = "en"
    time_zone = "America/Los_Angeles"
    }
  }
}
