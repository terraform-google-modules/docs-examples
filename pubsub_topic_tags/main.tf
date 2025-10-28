resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
  tags = {
    (google_tags_tag_key.tag_key.namespaced_name) = google_tags_tag_value.tag_value.short_name
  }
}

data "google_project" "project" {}

resource "google_tags_tag_key" "tag_key" {
  parent     = data.google_project.project.id
  short_name = "tag_key-${local.name_suffix}"
}

resource "google_tags_tag_value" "tag_value" {
  parent     = google_tags_tag_key.tag_key.id
  short_name = "tag_value-${local.name_suffix}"
}
