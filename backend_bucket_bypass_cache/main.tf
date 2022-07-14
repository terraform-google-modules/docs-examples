resource "google_compute_backend_bucket" "image_backend" {
  name        = "image-backend-bucket-${local.name_suffix}"
  description = "Contains beautiful images"
  bucket_name = google_storage_bucket.image_bucket.name
  enable_cdn  = true
  cdn_policy {
    bypass_cache_on_request_headers {
      header_name = "test"
    }
  }
}

resource "google_storage_bucket" "image_bucket" {
  name     = "image-store-bucket-${local.name_suffix}"
  location = "EU"
}
