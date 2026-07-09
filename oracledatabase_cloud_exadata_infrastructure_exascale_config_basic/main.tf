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

resource "google_oracle_database_cloud_exadata_infrastructure_exascale_config" "my_exascale_config" {
  cloud_exadata_infrastructure = google_oracle_database_cloud_exadata_infrastructure.infra.cloud_exadata_infrastructure_id
  location                     = "us-east4"
  project                      = "my-project-${local.name_suffix}"
  total_storage_size_gb        = 10240
}
