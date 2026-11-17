resource "google_storage_bucket" "bucket_for_my_iceberg_catalog" {
  name          = "my_iceberg_catalog-${local.name_suffix}"
  location      = "us-central1"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_biglake_iceberg_catalog" "my_iceberg_catalog" {
    name = google_storage_bucket.bucket_for_my_iceberg_catalog.name
    catalog_type = "CATALOG_TYPE_GCS_BUCKET"
    credential_mode = "CREDENTIAL_MODE_VENDED_CREDENTIALS"
    primary_location = "us-central1"
    depends_on = [
      google_storage_bucket.bucket_for_my_iceberg_catalog
    ]
}
