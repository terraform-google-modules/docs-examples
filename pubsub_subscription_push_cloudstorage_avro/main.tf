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
  topic = google_pubsub_topic.example.name

  cloud_storage_config {
    bucket = google_storage_bucket.example.name

    filename_prefix = "pre-"
    filename_suffix = "-%{random_suffix}"
  
    max_bytes = 1000
    max_duration = "300s"
  
    avro_config {
      write_metadata = true
    }
  }
  depends_on = [ 
    google_storage_bucket.example,
    google_storage_bucket_iam_member.admin,
  ]
}

data "google_project" "project" {
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = google_storage_bucket.example.name
  role   = "roles/storage.admin"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
