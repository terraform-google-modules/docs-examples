resource "google_beyondcorp_security_gateway" "default" {
  security_gateway_id = "default-${local.name_suffix}"
  display_name = "My Security Gateway resource"
  hubs { region = "us-central1" }
}

resource "google_beyondcorp_application" "example" {
  security_gateways_id = google_beyondcorp_security_gateway.default.security_gateway_id
  application_id = "google-${local.name_suffix}"
  endpoint_matchers {
    hostname = "google.com"
  }
}
