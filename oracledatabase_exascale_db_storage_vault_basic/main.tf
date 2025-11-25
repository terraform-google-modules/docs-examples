resource "google_oracle_database_exascale_db_storage_vault" "my_storage_vault"{
  exascale_db_storage_vault_id = "my-instance-${local.name_suffix}"
  display_name = "my-instance-${local.name_suffix} displayname"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  properties {
    exascale_db_storage_details {
        total_size_gbs = 512
    }
  }

  deletion_protection = "true-${local.name_suffix}"
}
