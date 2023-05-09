resource "google_cloud_run_v2_service" "default" {
  provider = google-beta
  name     = "cloudrun-service-${local.name_suffix}"
  location = "us-central1"
  launch_stage = "BETA"
  ingress = "INGRESS_TRAFFIC_ALL"
  template {
    containers {
      name = "hello-1"
      ports {
        container_port = 8080
      }
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      depends_on = ["hello-2"]
      volume_mounts {
        name = "empty-dir-volume"
	mount_path = "/mnt"
      }
    }
    containers {
      name = "hello-2"
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
    volumes {
      name = "empty-dir-volume"
      empty_dir {
        medium = "MEMORY"
        size_limit = "256Mi"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}
