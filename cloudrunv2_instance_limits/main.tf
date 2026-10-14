resource "google_cloud_run_v2_instance" "default" {
  name     = "cloudrun-instance-${local.name_suffix}"
  location = "us-east4"

  containers {
    image = "us-docker.pkg.dev/cloudrun/container/hello"
    resources {
      limits = {
        cpu    = "2"
        memory = "1024Mi"
      }
    }
  }
}
