resource "google_cloud_run_v2_instance" "default" {
  name         = "cloudrun-instance-${local.name_suffix}"
  location     = "us-west4"
  launch_stage = "BETA"

  containers {
    image            = "us-docker.pkg.dev/cloudrun/container/hello"
    sandbox_launcher = true
  }
  sandboxes {
    templates {
      name  = "hello"
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
}
