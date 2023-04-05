resource "google_network_security_gateway_security_policies" "default" {
  provider    = google-beta
  name        = "my-gateway-security-policy-${local.name_suffix}"
  location    = "us-central1"
  description = "my description"
}
