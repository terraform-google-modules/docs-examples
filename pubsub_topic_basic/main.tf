resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"

  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}
