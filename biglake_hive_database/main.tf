resource "google_storage_bucket" "bucket" {
  name          = "example-bucket-${local.name_suffix}"
  location      = "us-central1"
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_biglake_hive_catalog" "catalog" {
  name             = "tf_test_catalog%{random_suffix}"
  primary_location = "us-central1"
  location_uri     = "gs://${google_storage_bucket.bucket.name}"
}

resource "google_biglake_hive_database" "my_hive_database" {
  catalog      = google_biglake_hive_catalog.catalog.name
  name         = "tf_test_database%{random_suffix}"
  location_uri = "gs://${google_storage_bucket.bucket.name}"
  
  parameters = {
    key1 = "value1"
    key2 = "value2"
}


  description = "hive database description"
}
