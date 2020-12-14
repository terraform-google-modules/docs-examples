resource "google_pubsub_lite_topic" "example" {
  name = "example-topic-${local.name_suffix}"
  project = data.google_project.project.number
  partition_config {
    count = 1
    capacity {
      publish_mib_per_sec = 4
      subscribe_mib_per_sec = 8
    }
  }

  retention_config {
    per_partition_bytes = 32212254720
  }
}

resource "google_pubsub_lite_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_lite_topic.example.name
  delivery_config {
    delivery_requirement = "DELIVER_AFTER_STORED"
  }
}

data "google_project" "project" {
}
