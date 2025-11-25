resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {   
        time_zone = "America/Los_Angeles"
    }
}
resource "google_ces_tool" "ces_tool_client_function_basic" {
    location     = "us"
    app          = google_ces_app.my-app.name
    tool_id      = "ces_tool_basic1-${local.name_suffix}"
    execution_type = "SYNCHRONOUS"
    client_function {
        name = "ces_tool_client_function_basic-${local.name_suffix}"
        description = "example-description"
        parameters {
            description = "schema description"
            type        = "ARRAY"
            nullable    = true
            required = ["some_property"]
            enum = ["VALUE_A", "VALUE_B"]
            ref = "#/defs/MyDefinition"
            unique_items = true
            defs = jsonencode({
                SimpleString = {
                type        = "STRING"
                description = "A simple string definition"
            }})
            any_of = jsonencode([
                {
                type        = "STRING"
                description = "any_of option 1: string"
                },])
            default = jsonencode(
                false)
            prefix_items = jsonencode([
                {
                type        = "ARRAY"
                description = "prefix item 1"
                },])
            additional_properties = jsonencode(
                {
                type        = "BOOLEAN"
                })
            properties = jsonencode({
                name = {
                type        = "STRING"
                description = "A name"
            }})
            items = jsonencode({
                type        = "ARRAY"
                description = "An array"
            })
        }
        response {
            description = "schema description"
            type        = "ARRAY"
            nullable    = true
            required = ["some_property"]
            enum = ["VALUE_A", "VALUE_B"]
            ref = "#/defs/MyDefinition"
            unique_items = true
            defs = jsonencode({
                SimpleString = {
                type        = "STRING"
                description = "A simple string definition"
            }})
            any_of = jsonencode([
                {
                type        = "STRING"
                description = "any_of option 1: string"
                },])
            default = jsonencode(
                false)
            prefix_items = jsonencode([
                {
                type        = "ARRAY"
                description = "prefix item 1"
                },])
            additional_properties = jsonencode(
                {
                type        = "BOOLEAN"
                })
            properties = jsonencode({
                name = {
                type        = "STRING"
                description = "A name"
            }})
            items = jsonencode({
                type        = "ARRAY"
                description = "An array"
            })
        }
    }
}
