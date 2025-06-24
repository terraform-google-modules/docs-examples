resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false

  template {
    template {
      containers {
        name = "job-1"
        image = "us-docker.pkg.dev/cloudrun/container/job"
      }
      containers {
        name = "job-2"
        image = "us-docker.pkg.dev/cloudrun/container/job"
      }
    }
  }
}
