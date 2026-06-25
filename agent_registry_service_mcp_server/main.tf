resource "google_agent_registry_service" "default" {
  location     = "us-central1"
  service_id   = "service-${local.name_suffix}"
  description  = "My MCP agent registry service"
  display_name = "My Service"

  interfaces {
    url              = "https://example.com"
    protocol_binding = "JSONRPC"
  }

  mcp_server_spec {
    type    = "TOOL_SPEC"
    content = "{\"tools\":[]}"
  }
}
