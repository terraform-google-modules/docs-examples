resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv-${local.name_suffix}"
  location = "us-central1"

  metadata {
    annotations = {
      "run.googleapis.com/iap-enabled": true
    }
  }

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }
}
