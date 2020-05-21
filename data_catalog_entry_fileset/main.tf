resource "google_data_catalog_entry" "basic_entry" {
  entry_group = google_data_catalog_entry_group.entry_group.id
  entry_id = "my_entry-${local.name_suffix}"

  type = "FILESET"

  gcs_fileset_spec {
    file_patterns = ["gs://fake_bucket/dir/*"]
  }
}

resource "google_data_catalog_entry_group" "entry_group" {
  entry_group_id = "my_group-${local.name_suffix}"
}
