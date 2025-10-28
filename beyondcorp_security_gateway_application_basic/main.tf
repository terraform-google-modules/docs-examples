resource "google_beyondcorp_security_gateway" "default" {
  security_gateway_id = "default-sg-${local.name_suffix}"
  display_name = "My Security Gateway resource"
  hubs { region = "us-central1" }
}

resource "google_beyondcorp_security_gateway_application" "example" {
  security_gateway_id = google_beyondcorp_security_gateway.default.security_gateway_id
  application_id = "google-sga-${local.name_suffix}"
  endpoint_matchers {
    hostname = "google.com"
    ports = [80, 443]
  }
}
