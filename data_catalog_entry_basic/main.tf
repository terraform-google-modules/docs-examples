resource "google_data_catalog_entry" "basic_entry" {
  entry_group = google_data_catalog_entry_group.entry_group.id
  entry_id = "my_entry-${local.name_suffix}"

  user_specified_type = "my_custom_type"
  user_specified_system = "SomethingExternal"
}

resource "google_data_catalog_entry_group" "entry_group" {
  entry_group_id = "my_group-${local.name_suffix}"
}
