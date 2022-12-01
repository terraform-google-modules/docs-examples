resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job-${local.name_suffix}"
  location = "us-central1"
  launch_stage = "BETA"

  template {
    template{
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
        startup_probe {
          initial_delay_seconds = 0
          timeout_seconds = 1
          period_seconds = 3
          failure_threshold = 1
          tcp_socket {
            port = 8080
          }
        }
        liveness_probe {
          http_get {
            path = "/"
          }
        }
      }
    }
  }
}
