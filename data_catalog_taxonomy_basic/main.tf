resource "google_data_catalog_taxonomy" "basic_taxonomy" {
  display_name =  "my_taxonomy-${local.name_suffix}"
  description = "A collection of policy tags"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}
