resource "google_dialogflow_tool" "bearer_tool" {
  location     = "global"
  tool_key     = "bearer_token_tool_key-${local.name_suffix}"
  display_name = "bearer-tool"
  description  = "A tool with OpenAPI spec and Bearer Token Auth"

  open_api_spec {
    text_schema = <<EOF
openapi: 3.0.0
info:
  title: bearer_token_tool_key-${local.name_suffix}
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
      bearer_token_config {
        token                    = "secret-token"
        secret_version_for_token = "projects/-/secrets/-/versions/-"
      }
    }
  }
}
