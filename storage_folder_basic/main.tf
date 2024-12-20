resource "google_storage_bucket" "bucket" {
  name                        = "my-bucket-${local.name_suffix}"
  location                    = "EU"
  uniform_bucket_level_access = true
  hierarchical_namespace {
    enabled = true
  }
}

resource "google_storage_folder" "folder" {
  bucket        = google_storage_bucket.bucket.name
  name          = "parent-folder/"
}

resource "google_storage_folder" "subfolder" {
  bucket        = google_storage_bucket.bucket.name
  name          = "${google_storage_folder.folder.name}subfolder/"
}
