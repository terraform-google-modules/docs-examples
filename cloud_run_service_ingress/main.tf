resource "google_cloud_run_service" "default" {
  provider = google-beta
  name     = "ingress-service-${local.name_suffix}"
    location = "us-central1"

    template {
      spec {
        containers {
          image = "gcr.io/cloudrun/hello" #public image for your service
        }
      }
    }
    traffic {
      percent         = 100
      latest_revision = true
    }
    metadata {
      annotations = {
        # For valid annotation values and descriptions, see
        # https://cloud.google.com/sdk/gcloud/reference/run/deploy#--ingress
        "run.googleapis.com/ingress" = "internal"
      }
    }
}
