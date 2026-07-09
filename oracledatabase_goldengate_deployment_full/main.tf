resource "google_oracle_database_goldengate_deployment" "deployment" {
  goldengate_deployment_id = "my-deployment-${local.name_suffix}"
  display_name             = "my-deployment-${local.name_suffix} display name"
  location                 = "us-east4"
  project                  = "my-project-${local.name_suffix}"
  odb_subnet               = "projects/my-project/locations/us-east4/odbNetworks/my-network/odbSubnets/my-subnet-${local.name_suffix}"
  odb_network              = "projects/my-project/locations/us-east4/odbNetworks/my-network-${local.name_suffix}"
  gcp_oracle_zone          = "us-east4-b-r1"
  labels = {
    "label-one" = "value-one"
  }

  properties {
    deployment_type         = "DATABASE_ORACLE"
    cpu_core_count          = 1
    is_auto_scaling_enabled = false
    license_model           = "LICENSE_INCLUDED"
    environment_type        = "PRODUCTION"
    description             = "This is a test deployment"
    
    ogg_data {
      admin_username              = "admin"
      admin_password              = "123Abpassword!"
      deployment                  = "deployment"
    }

    maintenance_window {
      day        = "MONDAY"
      start_hour = 23
    }

    maintenance_config {
      is_interim_release_auto_upgrade_enabled = false
      interim_release_upgrade_period_days     = 0
      bundle_release_upgrade_period_days      = 1
      major_release_upgrade_period_days       = 2
      security_patch_upgrade_period_days      = 1
    }
  }
  deletion_policy = "PREVENT-${local.name_suffix}"

}
