resource "google_storage_bucket" "bucket" {
  name                        = "my-bucket-${local.name_suffix}"
  location                    = "EU"
  uniform_bucket_level_access = true
}

resource "google_storage_managed_folder" "folder" {
  bucket        = google_storage_bucket.bucket.name
  name          = "managed/folder/name/"
  force_destroy = true
}
