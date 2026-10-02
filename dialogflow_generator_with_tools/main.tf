resource "google_dialogflow_tool" "test_tool" {
  location     = "global"
  tool_key     = "generator_tool_key-${local.name_suffix}"
  display_name = "test-tool"
  description  = "A test tool"
  open_api_spec {
    text_schema = <<EOF
openapi: 3.0.0
info:
  title: generator_tool_key-${local.name_suffix}
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

resource "google_dialogflow_generator" "generator_with_tools" {
  location    = "global"
  description = "A generator with tools and free form context."
  tools       = [google_dialogflow_tool.test_tool.name]
  free_form_context {
    text = "Use the search tool to answer the user's query."
  }
  trigger_event = "MANUAL_CALL"
}
