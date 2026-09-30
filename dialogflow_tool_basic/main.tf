resource "google_dialogflow_tool" "basic_tool" {
  location     = "global"
  tool_id      = "basic_tool_key-${local.name_suffix}"
  tool_key     = "basic_tool_key-${local.name_suffix}"
  display_name = "basic-tool"
  description  = "A basic tool with OpenAPI spec"
  action_confirmation_requirement = {
    "searchAction" = "NOT_REQUIRED"
  }
  open_api_spec {
    text_schema = <<EOF
openapi: 3.0.0
info:
  title: basic_tool_key-${local.name_suffix}
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
  }
}
