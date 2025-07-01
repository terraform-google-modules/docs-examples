resource "google_discovery_engine_data_store" "kms_key_name" {
  location                     = "us"
  data_store_id                = "data-store-id-${local.name_suffix}"
  display_name                 = "tf-test-structured-datastore"
  industry_vertical            = "GENERIC"
  content_config               = "NO_CONTENT"
  solution_types               = ["SOLUTION_TYPE_SEARCH"]
  kms_key_name                 = "kms-key-${local.name_suffix}"
  create_advanced_site_search  = false
  skip_default_schema_creation = false
}
