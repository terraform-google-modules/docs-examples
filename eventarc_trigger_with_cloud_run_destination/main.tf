resource "google_eventarc_trigger" "primary" {
  name     = "some-trigger-${local.name_suffix}"
  location = "us-central1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  destination {
    cloud_run_service {
      service = google_cloud_run_service.default.name
      region  = "us-central1"
    }
  }
  labels = {
    foo = "bar"
  }
  transport {
    pubsub {
      topic = google_pubsub_topic.foo.id
    }
  }
}

resource "google_pubsub_topic" "foo" {
  name = "some-topic-${local.name_suffix}"
}

resource "google_cloud_run_service" "default" {
  name     = "some-service-${local.name_suffix}"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        ports {
          container_port = 8080
        }
      }
      container_concurrency = 50
      timeout_seconds       = 100
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
