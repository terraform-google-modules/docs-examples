resource "google_storage_bucket" "bucket_for_my_hive_catalog" {
  name          = "my_hive_catalog-${local.name_suffix}"
  location      = "us-central1"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_biglake_hive_catalog" "my_hive_catalog" {
  name = "my_hive_catalog-${local.name_suffix}"
  primary_location = "us-central1"
  location_uri = "gs://${google_storage_bucket.bucket_for_my_hive_catalog.name}"
  description = "terraform test hive catalog"
  depends_on = [
    google_storage_bucket.bucket_for_my_hive_catalog
  ]
}
