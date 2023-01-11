resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  ingress = "INGRESS_TRAFFIC_ALL"
  
  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
