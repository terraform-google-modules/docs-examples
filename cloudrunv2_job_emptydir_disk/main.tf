resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  launch_stage = "BETA"
  deletion_protection =  "true-${local.name_suffix}"

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
	  medium = "DISK"
	  size_limit = "10Gi"
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
