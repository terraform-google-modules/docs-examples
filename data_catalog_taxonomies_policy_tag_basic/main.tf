resource "google_data_catalog_policy_tag" "basic_policy_tag" {
  taxonomy = google_data_catalog_taxonomy.my_taxonomy.id
  display_name = "Low security"
  description = "A policy tag normally associated with low security items"
}

resource "google_data_catalog_taxonomy" "my_taxonomy" {
  display_name =  "taxonomy_display_name-${local.name_suffix}"
  description = "A collection of policy tags"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}
