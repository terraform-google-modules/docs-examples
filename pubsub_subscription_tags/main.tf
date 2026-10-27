resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.id
  tags = {
    (data.google_tags_tag_key.tag_key.namespaced_name) = data.google_tags_tag_value.tag_value.short_name
  }
}

data "google_project" "project" {}

data "google_tags_tag_key" "tag_key" {
  parent     = data.google_project.project.id
  short_name = "tag_key-${local.name_suffix}"
}

data "google_tags_tag_value" "tag_value" {
  parent     = data.google_tags_tag_key.tag_key.id
  short_name = "tag_value-${local.name_suffix}"
}
