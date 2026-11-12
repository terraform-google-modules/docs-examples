resource "google_cloud_run_v2_job" "default" {
  name                = "cloudrun-job-${local.name_suffix}"
  location            = "us-central1"
  deletion_protection = false
  launch_stage        = "BETA"

  template {
    template {
      containers {
        image            = "us-docker.pkg.dev/cloudrun/container/job"
        sandbox_launcher = true
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
  }
}
