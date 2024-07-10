resource "google_storage_bucket" "example" {
  name  = "example-bucket-${local.name_suffix}"
  location = "US"
  uniform_bucket_level_access = true
}

resource "google_pubsub_topic" "example" {
  name = "example-topic-${local.name_suffix}"
}

resource "google_pubsub_subscription" "example" {
  name  = "example-subscription-${local.name_suffix}"
  topic = google_pubsub_topic.example.id

  cloud_storage_config {
    bucket = google_storage_bucket.example.name

    filename_prefix = "pre-"
    filename_suffix = "-%{random_suffix}"
    filename_datetime_format = "YYYY-MM-DD/hh_mm_ssZ"

    max_bytes = 1000
    max_duration = "300s"

    service_account_email = google_service_account.storage_write_service_account.email
  }
  depends_on = [
    google_service_account.storage_write_service_account,
    google_storage_bucket.example,
    google_storage_bucket_iam_member.admin,
  ]
}

data "google_project" "project" {
}

resource "google_service_account" "storage_write_service_account" {
  account_id = "example-stw-${local.name_suffix}"
  display_name = "Storage Write Service Account"
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = google_storage_bucket.example.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.storage_write_service_account.email}"
}