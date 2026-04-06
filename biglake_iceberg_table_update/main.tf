resource "google_storage_bucket" "bucket" {
  name          = "my-bucket-${local.name_suffix}"
  location      = "us-central1"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_biglake_iceberg_catalog" "catalog" {
  name = google_storage_bucket.bucket.name
  catalog_type = "CATALOG_TYPE_GCS_BUCKET"
}

resource "google_biglake_iceberg_namespace" "namespace" {
  catalog = google_biglake_iceberg_catalog.catalog.name
  namespace_id = "my_namespace-${local.name_suffix}"
}

resource "google_biglake_iceberg_table" "my_iceberg_table" {
  catalog   = google_biglake_iceberg_catalog.catalog.name
  namespace = google_biglake_iceberg_namespace.namespace.namespace_id
  name      = "my_table-${local.name_suffix}"
  schema {
    type = "struct"
    fields {
      id       = 1
      name     = "id"
      type     = "long"
      required = true
    }
  }

  properties = {
    key = "value"
  }
}
