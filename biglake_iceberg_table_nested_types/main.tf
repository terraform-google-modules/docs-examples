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
    # List, map and struct types are JSON objects following the Iceberg spec.
    # Field IDs are unique across the schema: nested IDs (5-9) come after the
    # top-level ones (1-4), the order in which Iceberg assigns them.
    fields {
      id   = 2
      name = "tags"
      type = jsonencode({
        type               = "list"
        "element-id"       = 5
        element            = "string"
        "element-required" = false
      })
      required = false
    }
    fields {
      id   = 3
      name = "attributes"
      type = jsonencode({
        type             = "map"
        "key-id"         = 6
        key              = "string"
        "value-id"       = 7
        value            = "long"
        "value-required" = false
      })
      required = false
    }
    fields {
      id   = 4
      name = "address"
      type = jsonencode({
        type = "struct"
        fields = [
          { id = 8, name = "street", type = "string", required = false },
          { id = 9, name = "city", type = "string", required = false },
        ]
      })
      required = false
    }
  }
}
