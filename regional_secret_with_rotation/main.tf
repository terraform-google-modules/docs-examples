data "google_project" "project" {}

resource "google_pubsub_topic" "topic" {
  name = "tf-topic-${local.name_suffix}"
}

resource "google_pubsub_topic_iam_member" "secrets_manager_access" {
  topic  = google_pubsub_topic.topic.name
  role   = "roles/pubsub.publisher"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-secretmanager.iam.gserviceaccount.com"
}

resource "google_secret_manager_regional_secret" "regional-secret-with-rotation" {
  secret_id = "tf-reg-secret-${local.name_suffix}"
  location = "us-central1"

  topics {
    name = google_pubsub_topic.topic.id
  }

  rotation {
    rotation_period = "3600s"
    next_rotation_time = "2045-11-30T00:00:00Z-${local.name_suffix}"
  }

  depends_on = [
    google_pubsub_topic_iam_member.secrets_manager_access,
  ]
}
