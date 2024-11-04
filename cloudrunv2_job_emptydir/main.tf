resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  deletion_protection = false
  template {
    template {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/job"
	volume_mounts {
	  name = "empty-dir-volume"
	  mount_path = "/mnt"
	}
      }
      volumes {
        name = "empty-dir-volume"
	empty_dir {
	  medium = "MEMORY"
	  size_limit = "128Mi"
	}
      }
    }
  }
}
