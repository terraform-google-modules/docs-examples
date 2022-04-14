resource "google_cloud_deploy_delivery_pipeline" "pipeline" {
  name          = "dev-${local.name_suffix}"
  description   = "Dev Pipeline"
  serial_pipeline {
    stages {
      target_id = "dev"
    }
  }
  annotations = {
    generated-by = "magic-modules"
  }
  labels = {
    env = "dev"
  }
  region        = "us-central1"
}
