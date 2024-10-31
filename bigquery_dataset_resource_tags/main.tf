data "google_project" "project" {}

resource "google_tags_tag_key" "tag_key1" {
  parent     = data.google_project.project.id
  short_name = "tag_key1-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value1" {
  parent     = google_tags_tag_key.tag_key1.id
  short_name = "tag_value1-${local.name_suffix}"
}

resource "google_tags_tag_key" "tag_key2" {
  parent     = data.google_project.project.id
  short_name = "tag_key2-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value2" {
  parent     = google_tags_tag_key.tag_key2.id
  short_name = "tag_value2-${local.name_suffix}"
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id    = "dataset-${local.name_suffix}"
  friendly_name = "test"
  description   = "This is a test description"
  location      = "EU"

  resource_tags = {
    (google_tags_tag_key.tag_key1.namespaced_name) = google_tags_tag_value.tag_value1.short_name
    (google_tags_tag_key.tag_key2.namespaced_name) = google_tags_tag_value.tag_value2.short_name
  }
}
