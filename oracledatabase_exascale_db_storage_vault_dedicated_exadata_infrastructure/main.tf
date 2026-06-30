resource "google_oracle_database_cloud_exadata_infrastructure" "infra" {
  cloud_exadata_infrastructure_id = "my-infra-${local.name_suffix}"
  display_name                    = "my-infra-${local.name_suffix} displayname"
  location                        = "us-east4"
  project                         = "my-project-${local.name_suffix}"

  properties {
    shape         = "Exadata.X9M"
    compute_count = "2"
    storage_count = "3"
  }

  deletion_protection = "true-${local.name_suffix}"
}

resource "google_oracle_database_cloud_exadata_infrastructure_exascale_config" "exascale_config" {
  cloud_exadata_infrastructure = google_oracle_database_cloud_exadata_infrastructure.infra.cloud_exadata_infrastructure_id
  location                     = "us-east4"
  project                      = "my-project-${local.name_suffix}"
  total_storage_size_gb        = 10240
}

resource "google_oracle_database_exascale_db_storage_vault" "my_storage_vault" {
  exascale_db_storage_vault_id = "my-instance-${local.name_suffix}"
  display_name                 = "my-instance-${local.name_suffix} displayname"
  location                     = "us-east4"
  project                      = "my-project-${local.name_suffix}"

  exadata_infrastructure       = google_oracle_database_cloud_exadata_infrastructure.infra.name

  depends_on = [google_oracle_database_cloud_exadata_infrastructure_exascale_config.exascale_config]

  properties {
    exascale_db_storage_details {
      total_size_gbs = 2048
    }
  }

  deletion_protection = "true-${local.name_suffix}"
}
