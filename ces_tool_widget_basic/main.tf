resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {   
        time_zone = "America/Los_Angeles"
    }
}

resource "google_ces_tool" "ces_tool_widget_basic" {
    location       = "us"
    app            = google_ces_app.my-app.name
    tool_id        = "ces_tool_basic7-${local.name_suffix}"
    execution_type = "SYNCHRONOUS"
    widget_tool {
        name        = "ces_tool_widget_basic-${local.name_suffix}"
        description = "example-description"
        widget_type = "PRODUCT_CAROUSEL"
        ui_config = jsonencode({
            displaySettings = {
                showHeader = true
            }
        })
        data_mapping {
            mode = "FIELD_MAPPING"
            field_mappings = {
                "key1" = "value1"
                "key2" = "value2"
            }
        }
        text_response_config {
            type = "STATIC"
            static_text = "example-static-text"
        }
        parameters {
            type = "OBJECT"
            properties = jsonencode({
                param1 = {
                    type = "STRING"
                }
            })
        }
    }
}
