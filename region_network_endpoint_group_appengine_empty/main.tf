// App Engine Example
resource "google_compute_region_network_endpoint_group" "appengine_neg" {
  name                  = "appengine-neg-${local.name_suffix}"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  app_engine {
  }
}
