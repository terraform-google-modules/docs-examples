resource "google_beyondcorp_security_gateway" "default" {
  security_gateway_id = "default-sg-spa-api-${local.name_suffix}"
  display_name = "My SPA Security Gateway resource"
}

resource "google_beyondcorp_security_gateway_application" "example-spa" {
  security_gateway_id = google_beyondcorp_security_gateway.default.security_gateway_id
  application_id = "app-discovery-${local.name_suffix}"
  upstreams {
    external {
      endpoints {
        hostname = "my.discovery.service.com"
        port = 443
      }
    }
    proxy_protocol {
      allowed_client_headers= ["header"]
    }
  }
  schema = "API_GATEWAY"
}
