resource "google_dialogflow_tool" "auth_tool" {
  location     = "global"
  tool_key     = "auth_tool_key-${local.name_suffix}"
  display_name = "auth-tool"
  description  = "A tool with OpenAPI spec and API Key Auth"

  open_api_spec {
    text_schema = <<EOF
openapi: 3.0.0
info:
  title: auth_tool_key-${local.name_suffix}
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
      api_key_config {
        key_name                    = "X-API-KEY"
        api_key                     = "secret-key"
        secret_version_for_api_key  = "projects/-/secrets/-/versions/-"
        request_location            = "HEADER"
      }
    }
  }
}
