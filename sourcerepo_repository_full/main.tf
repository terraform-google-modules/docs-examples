resource "google_service_account" "test_account" {
  account_id   = "my-account-${local.name_suffix}"
  display_name = "Test Service Account"
}

resource "google_pubsub_topic" "topic" {
  name     = "my-topic-${local.name_suffix}"
}

resource "google_sourcerepo_repository" "my-repo" {
  name = "my-repository-${local.name_suffix}"
  pubsub_configs {
      topic = google_pubsub_topic.topic.id
      message_format = "JSON"
      service_account_email = google_service_account.test_account.email
  }
}
