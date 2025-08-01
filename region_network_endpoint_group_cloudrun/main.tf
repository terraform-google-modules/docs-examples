// Cloud Run Example
resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "cloudrun-neg-${local.name_suffix}"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  cloud_run {
    service = google_cloud_run_service.cloudrun_neg.name
  }
}

resource "google_cloud_run_service" "cloudrun_neg" {
  name     = "cloudrun-neg-${local.name_suffix}"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
