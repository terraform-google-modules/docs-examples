resource "google_compute_backend_bucket" "image_backend" {
  name        = "image-backend-bucket-${local.name_suffix}"
  description = "Contains beautiful images"
  bucket_name = google_storage_bucket.image_backend.name
  enable_cdn  = true
  edge_security_policy = google_compute_security_policy.policy.id
}

resource "google_storage_bucket" "image_backend" {
  name     = "image-store-bucket-${local.name_suffix}"
  location = "EU"
}

resource "google_compute_security_policy" "policy" {
  name        = "image-store-bucket-${local.name_suffix}"
  description = "basic security policy"
	type = "CLOUD_ARMOR_EDGE"
}
