resource "google_compute_backend_service" "default" {
  name                  = "tf-test-backend-service-external-${local.name_suffix}"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  iap {
    enabled              = true
    oauth2_client_id     = "abc"
    oauth2_client_secret = "xyz"
  }
}
