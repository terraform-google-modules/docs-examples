data "google_project" "project" {
}

resource "google_tags_tag_key" "tag_key1" {
  parent = "projects/${data.google_project.project.number}"
  short_name = "tag_key1-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value1" {
  parent = "tagKeys/${google_tags_tag_key.tag_key1.name}"
  short_name = "tag_value1-${local.name_suffix}"
}

resource "google_tags_tag_key" "tag_key2" {
  parent = "projects/${data.google_project.project.number}"
  short_name = "tag_key2-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value2" {
  parent = "tagKeys/${google_tags_tag_key.tag_key2.name}"
  short_name = "tag_value2-${local.name_suffix}"
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "dataset-${local.name_suffix}"
  friendly_name               = "test"
  description                 = "This is a test description"
  location                    = "EU"

  resource_tags = {
    "${data.google_project.project.project_id}/${google_tags_tag_key.tag_key1.short_name}" = "${google_tags_tag_value.tag_value1.short_name}"
    "${data.google_project.project.project_id}/${google_tags_tag_key.tag_key2.short_name}" = "${google_tags_tag_value.tag_value2.short_name}"
  }
}
