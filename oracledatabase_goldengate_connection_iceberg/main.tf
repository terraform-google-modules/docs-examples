resource "google_oracle_database_goldengate_connection" "connection" {
  goldengate_connection_id = "my-connection-${local.name_suffix}"
  location                 = "us-east4"
  project                  = "my-project-${local.name_suffix}"
  gcp_oracle_zone          = "us-east4-b-r1"

  properties {
    display_name    = "my-connection-${local.name_suffix} display name"
    connection_type = "ICEBERG"
    iceberg_connection_properties {
      technology_type = "APACHE_ICEBERG"
      catalog {
        catalog_type = "GLUE"
        glue_iceberg_catalog {
          glue_id = "glue_catalog_id"
        }
      }
      storage {
        storage_type = "AMAZON_S3"
        amazon_s3_iceberg_storage {
          scheme_type              = "S3"
          access_key_id            = "AKIAIOSFODNN7EXAMPLE"
          secret_access_key_secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
          region                   = "us-east-1"
          bucket                   = "iceberg-bucket"
          endpoint                 = "https://s3.amazonaws.com"
        }
      }
    }
  }
  deletion_protection = "true-${local.name_suffix}"
}
