resource "google_network_security_server_tls_policy" "default" {
  provider               = google-beta
  name                   = "my-server-tls-policy-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description            = "my description"
  location               = "global"
  allow_open             = "false"
  mtls_policy {
    client_validation_mode = "ALLOW_INVALID_OR_MISSING_CLIENT_CERT"
  }
}
