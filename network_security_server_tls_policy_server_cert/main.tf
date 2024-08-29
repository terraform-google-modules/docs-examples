resource "google_network_security_server_tls_policy" "default" {
  name                   = "my-server-tls-policy-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description            = "my description"
  location               = "global"
  allow_open             = "false"
  server_certificate {
    grpc_endpoint {
        target_uri = "unix:mypath"
      }
  }
}
