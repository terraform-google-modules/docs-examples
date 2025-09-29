resource "google_beyondcorp_security_gateway" "default" {
  security_gateway_id = "default-sg-spa-proxy-${local.name_suffix}"
  display_name = "My SPA Security Gateway resource"
}

resource "google_beyondcorp_security_gateway_application" "example-spa" {
  security_gateway_id = google_beyondcorp_security_gateway.default.security_gateway_id
  application_id = "app-proxy-${local.name_suffix}"
  endpoint_matchers {
    hostname = "a.site.com"
    ports = [443]
  }
  upstreams {
    external {
      endpoints {
        hostname = "my.proxy.service.com"
        port = 443
      }
    }
    proxy_protocol {
      allowed_client_headers = ["header1", "header2"]
      contextual_headers {
        user_info {
          output_type = "PROTOBUF"
        }
        group_info {
          output_type = "JSON"
        }
        device_info {
          output_type = "NONE"
        }
        output_type = "JSON"
      }
      metadata_headers = {
        metadata-header1 = "value1"
        metadata-header2 = "value2"
      }
      gateway_identity = "RESOURCE_NAME"
      client_ip = true
    }
  }
  schema = "PROXY_GATEWAY"
}
