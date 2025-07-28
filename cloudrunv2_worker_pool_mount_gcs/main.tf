resource "google_cloud_run_v2_worker_pool" "default" {
  name     = "cloudrun-worker-pool-${local.name_suffix}"

  location     = "us-central1"
  deletion_protection = false
  launch_stage = "BETA"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/worker-pool"
      volume_mounts {
        name       = "bucket"
        mount_path = "/var/www"
      }
    }

    volumes {
      name = "bucket"
      gcs {
        bucket    = google_storage_bucket.default.name
        read_only = false
      }
    }
  }
}

resource "google_storage_bucket" "default" {
    name     = "cloudrun-worker-pool-${local.name_suffix}"
    location = "US"
    uniform_bucket_level_access = true
}
