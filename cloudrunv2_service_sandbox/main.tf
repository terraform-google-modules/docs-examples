resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  launch_stage = "BETA"
  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      sandbox_launcher = true
    }
  }
}
