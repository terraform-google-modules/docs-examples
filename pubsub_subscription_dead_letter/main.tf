resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_topic" "example_dead_letter" {
  name = "example-topic-${local.name_suffix}-dead-letter"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.name

  dead_letter_policy {
    dead_letter_topic = google_pubsub_topic.example_dead_letter.id
    max_delivery_attempts = 10
  }
}
