resource "google_data_catalog_entry_group" "basic_entry_group" {
  entry_group_id = "my_group-${local.name_suffix}"

  display_name = "terraform entry group"
  description = "entry group created by Terraform"
}
