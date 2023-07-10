resource "google_network_security_gateway_security_policy" "default" {
  name        = "my-gateway-security-policy-${local.name_suffix}"
  location    = "us-central1"
  description = "my description"
}
