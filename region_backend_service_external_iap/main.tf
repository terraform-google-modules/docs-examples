resource "google_compute_region_backend_service" "default" {
  name                  = "tf-test-region-service-external-${local.name_suffix}"
  region                = "us-central1"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  iap {
    enabled              = true
    oauth2_client_id     = "abc"
    oauth2_client_secret = "xyz"
  }
}
