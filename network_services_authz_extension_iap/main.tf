resource "google_network_services_authz_extension" "default" {
  name     = "my-authz-ext-${local.name_suffix}"
  location = "us-west1"

  service               = "iap.googleapis.com"
  timeout               = "0.1s"
}
