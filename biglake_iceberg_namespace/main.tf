resource "google_storage_bucket" "bucket" {
  name          = "example-bucket-${local.name_suffix}"
  location      = "us-central1"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_biglake_iceberg_catalog" "catalog" {
  name = google_storage_bucket.bucket.name
  catalog_type = "CATALOG_TYPE_GCS_BUCKET"
}

resource "google_biglake_iceberg_namespace" "my_iceberg_namespace" {
  catalog = google_biglake_iceberg_catalog.catalog.name
  namespace_id = "my_iceberg_namespace"
  properties = {
    key = "value"
  }
}
