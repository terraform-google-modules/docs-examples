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
    depends_on = [
      google_storage_bucket.bucket_for_my_iceberg_catalog
    ]
}

# You need to grant an appropriate role to the credential vending service account.
# The service account will generate tokens for accessing the GCS bucket.
# You do not need this if using the other credential_mode.
# resource "google_storage_bucket_iam_member" "cv_sa_storage_admin" {
#  bucket = google_storage_bucket.bucket_for_my_iceberg_catalog.name
#  role = "roles/storage.admin"
#  member = "serviceAccount:${google_biglake_iceberg_catalog.my_iceberg_catalog.biglake_service_account}"
#}
