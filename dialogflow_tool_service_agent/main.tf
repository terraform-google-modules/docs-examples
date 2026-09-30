resource "google_dialogflow_tool" "service_agent_tool" {
  location     = "global"
  tool_key     = "service_agent_tool_key-${local.name_suffix}"
  display_name = "service-agent-tool"
  description  = "A tool with OpenAPI spec and Service Agent Auth"

  open_api_spec {
    text_schema = <<EOF
openapi: 3.0.0
info:
  title: service_agent_tool_key-${local.name_suffix}
  version: 1.0.0
paths:
  /search:
    get:
      summary: Search function
      operationId: searchAction
      responses:
        '200':
          description: OK
EOF
    authentication {
      service_agent_auth_config {
        service_agent_auth = "ID_TOKEN"
      }
    }
  }
}
