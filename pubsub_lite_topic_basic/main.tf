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

data "google_project" "project" {
}
