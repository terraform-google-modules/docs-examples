resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  launch_stage = "GA"
  template {
    template{
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/job"
      }
      vpc_access {
        network_interfaces {
          network = "default"
          subnetwork = "default"
          tags = ["tag1", "tag2", "tag3"]
        }
      }
    }
  }
}
