resource "google_cloud_run_v2_instance" "default" {
  name         = "cloudrun-instance-${local.name_suffix}"
  location     = "us-west4"
  launch_stage = "BETA"

  containers {
    image            = "us-docker.pkg.dev/cloudrun/container/hello"
    sandbox_launcher = false
    volume_mounts {
      name = "empty-dir-volume"
      mount_path = "/mnt"
    }
  }
  sandboxes {
    templates {
      name  = "hello"
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      command = ["/bin/sh"]
      args = ["foo"]
      env {
        name = "PORT"
        value = "8080"
      }
      volume_mounts {
        name = "empty-dir-volume"
        mount_path = "/mnt"
        sub_path = "/home/user"
      }
      working_dir = "/mnt/app"
    }
  }
  volumes {
    name = "empty-dir-volume"
    empty_dir {
      medium = "MEMORY"
      size_limit = "256Mi"
    }
  }
}
