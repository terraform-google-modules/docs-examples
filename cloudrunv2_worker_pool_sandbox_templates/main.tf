resource "google_cloud_run_v2_worker_pool" "default" {
  name     = "cloudrun-example-${local.name_suffix}"
  location = "us-west1"
  deletion_protection = false
  launch_stage = "BETA"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      sandbox_launcher = true
    }
    sandboxes {
      templates {
        name  = "hello"
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}
