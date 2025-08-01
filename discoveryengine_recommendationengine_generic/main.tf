resource "google_discovery_engine_data_store" "generic" {
  location                     = "global"
  data_store_id                = "recommendation-datastore-id-${local.name_suffix}"
  display_name                 = "tf-test-structured-datastore"
  industry_vertical            = "GENERIC"
  content_config               = "NO_CONTENT"
  solution_types               = ["SOLUTION_TYPE_RECOMMENDATION"]
  create_advanced_site_search  = false
  skip_default_schema_creation = false
}
resource "google_discovery_engine_recommendation_engine" "generic" {
  engine_id                    = "recommendation-engine-id-${local.name_suffix}"
  location                     = google_discovery_engine_data_store.generic.location
  display_name                 = "Example Recommendation Engine"
  data_store_ids               = [google_discovery_engine_data_store.generic.data_store_id]
  industry_vertical            = "GENERIC"
  common_config {
    company_name               = "test-company"
  }
}
