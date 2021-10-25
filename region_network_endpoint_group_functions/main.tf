// Cloud Functions Example
resource "google_compute_region_network_endpoint_group" "function_neg" {
  name                  = "function-neg-${local.name_suffix}"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  cloud_function {
    function = google_cloudfunctions_function.function_neg.name
  }
}

resource "google_cloudfunctions_function" "function_neg" {
  name        = "function-neg-${local.name_suffix}"
  description = "My function"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  timeout               = 60
  entry_point           = "helloGET"
}

resource "google_storage_bucket" "bucket" {
  name     = "cloudfunctions-function-example-bucket-${local.name_suffix}"
  location = "US"
}

resource "google_storage_bucket_object" "archive" { 
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "path/to/index.zip-${local.name_suffix}"
}
