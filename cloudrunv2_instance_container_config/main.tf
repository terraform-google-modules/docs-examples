resource "google_cloud_run_v2_instance" "default" {
  name                 = "cloudrun-instance-${local.name_suffix}"
  location             = "us-east4"
  client               = "terraform"
  client_version       = "1.0.0"

  containers {
    name        = "custom-container"
    image       = "us-docker.pkg.dev/cloudrun/container/hello"
    command     = ["/server"]
    args        = ["--port=8080"]
    working_dir = "/"
    ports {
      name           = "http1"
      container_port = 8080
    }
    env {
      name  = "CUSTOM_ENV"
      value = "custom_value"
    }
    volume_mounts {
      name       = "empty-dir-volume"
      mount_path = "/mnt"
      sub_path   = "sub"
    }
  }

  volumes {
    name = "empty-dir-volume"
    empty_dir {
      medium     = "MEMORY"
      size_limit = "128Mi"
    }
  }
}
