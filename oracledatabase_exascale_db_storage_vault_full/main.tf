resource "google_oracle_database_exascale_db_storage_vault" "my_storage_vault"{
  exascale_db_storage_vault_id = "my-instance-${local.name_suffix}"
  display_name = "my-instance-${local.name_suffix} displayname"
  location = "us-east4"
  gcp_oracle_zone = "us-east4-b-r1"
  project = "my-project-${local.name_suffix}"
  labels = {
    "label-one" = "value-one"
  }
  properties {
    time_zone {
        id = "UTC"
    }
    additional_flash_cache_percent = 100
    exascale_db_storage_details {
        total_size_gbs = 300
    }
  }

  deletion_protection = "true-${local.name_suffix}"
}
