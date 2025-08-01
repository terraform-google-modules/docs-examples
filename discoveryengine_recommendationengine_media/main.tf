resource "google_discovery_engine_data_store" "media" {
  location                     = "global"
  data_store_id                = "recommendation-datastore-id-${local.name_suffix}"
  display_name                 = "tf-test-structured-datastore"
  industry_vertical            = "MEDIA"
  content_config               = "NO_CONTENT"
  solution_types               = ["SOLUTION_TYPE_RECOMMENDATION"]
  create_advanced_site_search  = false
  skip_default_schema_creation = false
}
resource "google_discovery_engine_recommendation_engine" "media" {
  engine_id                    = "recommendation-engine-id-${local.name_suffix}"
  location                     = google_discovery_engine_data_store.media.location
  display_name                 = "Example Media Recommendation Engine"
  data_store_ids               = [google_discovery_engine_data_store.media.data_store_id]
  industry_vertical            = "MEDIA"
  media_recommendation_engine_config {
    type                       = "recommended-for-you"
    optimization_objective     = "ctr"
    training_state             = "PAUSED"
    engine_features_config {
        recommended_for_you_config {
            context_event_type = "generic"
        }
    }
  }
  common_config {
    company_name               = "test-company"
  }
}
