resource "google_discovery_engine_data_store" "test_data_store" {
  location                    = "eu"
  data_store_id               = "data-store-${local.name_suffix}"
  display_name                = "Structured datastore"
  industry_vertical           = "GENERIC"
  content_config              = "NO_CONTENT"
  solution_types              = ["SOLUTION_TYPE_CHAT"]
}

resource "google_dialogflow_cx_agent" "agent" {
  display_name = "dialogflowcx-agent"
  location = "europe-west3"
  default_language_code = "en"
  time_zone = "America/Los_Angeles"
}

resource "google_discovery_engine_chat_engine" "primary" {
  engine_id = "chat-engine-id-${local.name_suffix}"
  collection_id = "default_collection"
  location = google_discovery_engine_data_store.test_data_store.location
  display_name = "Chat engine"
  industry_vertical = "GENERIC"
  data_store_ids = [google_discovery_engine_data_store.test_data_store.data_store_id]
  common_config {
    company_name = "test-company"
  }
  chat_engine_config {
    dialogflow_agent_to_link = google_dialogflow_cx_agent.agent.id
    allow_cross_region = true
  }
}
