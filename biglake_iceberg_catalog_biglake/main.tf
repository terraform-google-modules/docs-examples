resource "google_storage_bucket" "default_bucket" {
  name                        = "my_iceberg_catalog-${local.name_suffix}-default"
  location                    = "us-central1"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "restricted_bucket" {
  name                        = "my_iceberg_catalog-${local.name_suffix}-restricted"
  location                    = "us-central1"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_biglake_iceberg_catalog" "my_iceberg_catalog" {
    name             = "my_iceberg_catalog-${local.name_suffix}"
    catalog_type     = "CATALOG_TYPE_BIGLAKE"
    credential_mode  = "CREDENTIAL_MODE_VENDED_CREDENTIALS"
    default_location = "gs://${google_storage_bucket.default_bucket.name}"
    restricted_locations_config {
      restricted_locations = [
        "gs://${google_storage_bucket.default_bucket.name}",
        "gs://${google_storage_bucket.restricted_bucket.name}",
      ]
    }
}
