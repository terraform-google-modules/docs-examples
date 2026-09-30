resource "google_dialogflow_tool" "function_tool" {
  location     = "global"
  tool_key     = "function_tool_key-${local.name_suffix}"
  display_name = "function-tool"
  description  = "A tool with Function spec"

  function_spec {
    method_type = "GET"
    input_schema = jsonencode({
      type = "object"
      properties = {
        param1 = { type = "string" }
      }
    })
    output_schema = jsonencode({
      type = "object"
      properties = {
        result = { type = "string" }
      }
    })
  }
}
