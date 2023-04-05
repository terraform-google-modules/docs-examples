resource "google_network_security_gateway_security_policies" "default" {
  provider    = google-beta
  name        = "my-gateway-security-policy-${local.name_suffix}"
  location    = "us-central1"
  description = "gateway security policy created to be used as reference by the rule."
}

resource "google_network_security_gateway_security_policies_rule" "default" {
  provider                = google-beta
  name                    = "my-gateway-security-policy-rule-${local.name_suffix}"
  location                = "us-central1"
  gateway_security_policy = google_network_security_gateway_security_policies.default.name
  enabled                 = true  
  description             = "my description"
  priority                = 0
  session_matcher         = "host() == 'example.com'"
  basic_profile           = "ALLOW"
}
