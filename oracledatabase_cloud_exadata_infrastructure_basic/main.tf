resource "google_oracle_database_cloud_exadata_infrastructure" "my-cloud-exadata"{
  cloud_exadata_infrastructure_id = "my-instance-${local.name_suffix}"
  display_name = "my-instance-${local.name_suffix} displayname"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  properties {
    shape = "Exadata.X9M"
    compute_count= "2"
    storage_count= "3"
  }
}
