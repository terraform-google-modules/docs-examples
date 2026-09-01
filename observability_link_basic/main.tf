# Force the creation of the Service Agent identity
resource "google_project_service_identity" "observability_sa" {
  service = "observability.googleapis.com"
}

# Buffer for the new identity to propagate to global IAM indexes
resource "time_sleep" "wait_for_sa_propagation" {
  create_duration = "30s"
  depends_on      = [
    google_project_service_identity.observability_sa
  ]
}

resource "google_project_iam_member" "observability_sa_bq_admin" {
  project = google_project_service_identity.observability_sa.project
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_project_service_identity.observability_sa.email}"

  depends_on = [
    time_sleep.wait_for_sa_propagation
  ]
}

resource "google_observability_bucket" "bucket" {
  bucket_id    = "_Trace"
  location     = "us"
  display_name = "Bucket for Link"
  description  = "Bucket for testing Link"
}

resource "google_observability_link" "primary" {
  location     = google_observability_bucket.bucket.location
  bucket       = google_observability_bucket.bucket.bucket_id
  dataset      = "Spans"
  link_id      = "link_test-${local.name_suffix}"
  display_name = "Initial Display Name"
  description  = "Initial description"

  depends_on = [
    google_project_iam_member.observability_sa_bq_admin,
  ]
}
