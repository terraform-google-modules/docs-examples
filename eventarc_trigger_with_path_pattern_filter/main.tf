resource "google_eventarc_trigger" "primary" {
  name     = "some-trigger-${local.name_suffix}"
  location = "us-central1"
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.eventarc.trigger.v1.created"
  }
  matching_criteria {
    attribute = "trigger"
    operator  = "match-path-pattern"
    value     = "trigger-with-wildcard-*"
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
  event_data_content_type = "application/protobuf"
  service_account         = google_service_account.trigger_service_account.email
  depends_on              = [google_project_iam_member.event_receiver]
}

resource "google_service_account" "trigger_service_account" {
  account_id = "trigger-sa-${local.name_suffix}"
}

resource "google_project_iam_member" "event_receiver" {
  project = google_service_account.trigger_service_account.project
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.trigger_service_account.email}"
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
