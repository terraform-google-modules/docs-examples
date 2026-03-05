resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-iap-service-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"
  iap_enabled = true

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
