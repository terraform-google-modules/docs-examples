resource "google_cloud_run_v2_job" "default" {
  provider = google-beta
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  launch_stage = "BETA"
  template {
    template {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
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

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}
