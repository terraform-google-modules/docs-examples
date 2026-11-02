data "google_project" "project" {}

resource "google_storage_bucket" "bucket" {
  name                        = "eval-item-bucket-${local.name_suffix}"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform.iam.gserviceaccount.com"
}

resource "google_storage_bucket_object" "object" {
  name   = "eval_request.json"
  bucket = google_storage_bucket.bucket.name
  content = jsonencode({
    prompt = {
      text = "What is the capital of France?"
    }
  })
}

resource "google_vertex_ai_evaluation_item" "evaluation_item_gcs" {
  region               = "us-central1"
  display_name         = "eval-item-${local.name_suffix}"
  evaluation_item_type = "REQUEST"
  gcs_uri              = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"

  depends_on = [
    google_storage_bucket_iam_member.viewer,
    google_storage_bucket_object.object,
  ]
}
