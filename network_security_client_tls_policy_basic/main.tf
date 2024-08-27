resource "google_network_security_client_tls_policy" "default" {
  name                   = "my-client-tls-policy-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description            = "my description"
  sni                    = "secure.example.com"
}
