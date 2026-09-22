resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    scaling {
      min_instance_count      = 1
      max_instance_count      = 5
      cpu_utilization         = 0.75
      concurrency_utilization = 0.5
    }
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
