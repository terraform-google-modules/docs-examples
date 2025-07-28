resource "google_cloud_run_v2_worker_pool" "default" {
  name     = "cloudrun-worker-pool-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  launch_stage = "BETA"
  
  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/worker-pool"
    }
  }
}
