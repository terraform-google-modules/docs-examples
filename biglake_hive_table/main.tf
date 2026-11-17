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

resource "google_biglake_hive_database" "database" {
  catalog      = google_biglake_hive_catalog.catalog.name
  name         = "tf_test_database%{random_suffix}"
  location_uri = "gs://${google_storage_bucket.bucket.name}"
}

resource "google_biglake_hive_table" "my_hive_table" {
  catalog  = google_biglake_hive_catalog.catalog.name
  database = google_biglake_hive_database.database.name
  name     = "tf_test_table%{random_suffix}"

  description = "Hive table description"
  storage_descriptor {
    columns {
  name    = "col0"
  type    = "STRING"
  comment = "column that will be deleted on update"
}
columns {
  name    = "col1"
  type    = "STRING"
  comment = "first skewed column"
}

    input_format         = "org.apache.hadoop.mapred.TextInputFormat"
    output_format        = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    compressed           = true
    num_buckets          = 1
    bucket_cols          = ["bucket_col1"]
    sort_cols {
  col   = "col1"
  order = 0
}

    skewed_info {
  skewed_col_names = ["col1"]
  skewed_col_values {
    values = ["val1"]
  }
  skewed_key_values_locations {
    values   = ["val1"]
    location = "gs://example-bucket/skewed_location_1"
  }
}

    serde_info {
      name               = "LazySimpleSerDe"
      serialization_lib  = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
    }
    parameters           = {
  key1 = "value1"
}

    stored_as_sub_dirs   = false
  }
  partition_keys {
  name    = "dt"
  type    = "STRING"
  comment = "date partition"
}

  parameters = {
  key1 = "value1"
}

}
