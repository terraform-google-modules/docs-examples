resource "google_compute_backend_bucket" "image_backend_full" {
  name        = "image-backend-bucket-full-${local.name_suffix}"
  description = "Contains beautiful beta mages"
  bucket_name = google_storage_bucket.image_backend_full.name
  enable_cdn  = true
  cdn_policy {
    cache_mode = "CACHE_ALL_STATIC"
    default_ttl = 3600
    client_ttl  = 7200
    max_ttl     = 10800
    negative_caching = true
  }
  custom_response_headers = [
    "X-Client-Geo-Location:{client_region},{client_city}",
    "X-Tested-By:Magic-Modules"
  ]
}

resource "google_storage_bucket" "image_backend_full" {
  name     = "image-store-bucket-full-${local.name_suffix}"
  location = "EU"
}
