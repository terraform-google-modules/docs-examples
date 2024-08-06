resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false

  template {
    template {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/job"
        resources {
          limits = {
            cpu    = "2"
            memory = "1024Mi"
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}
