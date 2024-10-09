resource "google_oracle_database_cloud_exadata_infrastructure" "my-cloud-exadata"{
  display_name = "OFake exadata displayname"
  cloud_exadata_infrastructure_id = "ofake-exadata"
  location = "us-east4"
  project = "my-project-${local.name_suffix}"
  properties {
    shape = "Exadata.X9M"
    compute_count= "2"
    storage_count= "3"
  }
}
