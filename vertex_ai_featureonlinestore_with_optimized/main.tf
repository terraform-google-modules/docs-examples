resource "google_vertex_ai_feature_online_store" "featureonlinestore" {
  provider = google
  name     = "example_feature_online_store_optimized-${local.name_suffix}"
  labels = {
    foo = "bar"
  }
  region = "us-central1"
  optimized {}
  dedicated_serving_endpoint {
    private_service_connect_config {
      enable_private_service_connect = true
      project_allowlist              = [data.google_project.project.number]
    }
  }
}

data "google_project" "project" {
  provider = google
}

