resource "google_storage_bucket" "bucket_for_my_iceberg_catalog" {
  name          = "my_iceberg_catalog-${local.name_suffix}"
  location      = "us-central1"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_biglake_iceberg_catalog" "my_iceberg_catalog" {
    name = "my_iceberg_catalog-${local.name_suffix}"
    catalog_type = "CATALOG_TYPE_GCS_BUCKET"
    depends_on = [
      google_storage_bucket.bucket_for_my_iceberg_catalog
    ]
}
