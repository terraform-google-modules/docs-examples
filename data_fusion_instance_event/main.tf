resource "google_data_fusion_instance" "event" {
  name    = "my-instance-${local.name_suffix}"
  region  = "us-central1"
  type    = "BASIC"

  event_publish_config {
    enabled = true
    topic   = google_pubsub_topic.event.id
  }
}

resource "google_pubsub_topic" "event" {
  name = "my-instance-${local.name_suffix}"
}
