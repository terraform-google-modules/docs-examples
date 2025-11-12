resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {   
        time_zone = "America/Los_Angeles"
    }
}
resource "google_ces_tool" "ces_tool_python_function_basic" {
    location       = "us"
    app            = google_ces_app.my-app.name
    tool_id        = "ces_tool_basic4-${local.name_suffix}"
    execution_type = "SYNCHRONOUS"
    python_function {
        name = "example_function"
        python_code = "def example_function() -> int: return 0"
    }
}
