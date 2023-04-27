resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"

  template {
    template {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}
