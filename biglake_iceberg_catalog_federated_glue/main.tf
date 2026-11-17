resource "google_biglake_iceberg_catalog" "my_iceberg_catalog" {
  catalog_type     = "CATALOG_TYPE_FEDERATED"
  name             = "my_iceberg_catalog-${local.name_suffix}"
  primary_location = "us-central1"

  federated_catalog_options {
    glue_catalog_info {
      aws_region   = "us-east-1"
      aws_role_arn = "arn:aws:iam::111222333444:role/my-glue-role"
      warehouse    = "111222333444:s3tablescatalog/example"
    }
    refresh_options {
      refresh_schedule {
        refresh_interval = "300s"
      }
    }
  }
}
