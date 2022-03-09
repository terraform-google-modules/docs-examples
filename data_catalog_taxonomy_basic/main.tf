resource "google_data_catalog_taxonomy" "basic_taxonomy" {
  provider = google-beta
  region = "us"
  display_name =  "my_display_name-${local.name_suffix}"
  description = "A collection of policy tags"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}
