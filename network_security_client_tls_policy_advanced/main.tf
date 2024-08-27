resource "google_network_security_client_tls_policy" "default" {
  name                   = "my-client-tls-policy-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description            = "my description"
  client_certificate {
    certificate_provider_instance {
        plugin_instance = "google_cloud_private_spiffe"
      }
    }
  server_validation_ca {
    grpc_endpoint {
      target_uri = "unix:mypath"
    }
  }
}
