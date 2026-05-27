resource "google_oracle_database_goldengate_deployment" "deployment" {
  goldengate_deployment_id = "my-deployment-${local.name_suffix}"
  display_name             = "my-deployment-${local.name_suffix} display name"
  location                 = "us-east4"
  project                  = "my-project-${local.name_suffix}"
  odb_subnet               = "projects/my-project/locations/us-east4/odbNetworks/my-network/odbSubnets/my-subnet-${local.name_suffix}"

  properties {
    deployment_type = "DATABASE_ORACLE"
    ogg_data {
      admin_username = "admin"
      admin_password = "123Abpassword!"
      deployment     = "deployment"
    }
  }
  deletion_policy = "PREVENT-${local.name_suffix}"
}
