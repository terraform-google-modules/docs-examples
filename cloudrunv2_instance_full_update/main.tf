resource "google_cloud_run_v2_instance" "default" {
  name                 = "cloudrun-instance-${local.name_suffix}"
  location             = "us-east4"
  ingress              = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  restart_policy       = "ALWAYS"
  launch_stage         = "GA"
  default_uri_disabled = false
  invoker_iam_disabled = false

  labels = {
    env = "production"
  }

  annotations = {
    test-annotation = "updated-value"
  }

  containers {
    image = "us-docker.pkg.dev/cloudrun/container/hello"
    ports {
      container_port = 8080
    }
    resources {
      limits = {
        cpu    = "2"
        memory = "2Gi"
      }
    }
  }
}
