resource "google_cloud_run_v2_instance" "default" {
  name                = "cloudrun-instance-${local.name_suffix}"
  location            = "us-east4"

  containers {
    image = "us-docker.pkg.dev/cloudrun/container/hello"
    startup_probe {
      initial_delay_seconds = 0
      timeout_seconds       = 1
      period_seconds        = 3
      failure_threshold     = 1
      grpc {
        port    = 8080
        service = "my-service"
      }
    }
    liveness_probe {
      initial_delay_seconds = 0
      timeout_seconds       = 1
      period_seconds        = 3
      failure_threshold     = 1
      grpc {
        port    = 8080
        service = "my-service"
      }
    }
  }
}
