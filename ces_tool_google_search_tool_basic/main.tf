resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {   
        time_zone = "America/Los_Angeles"
    }
}
resource "google_ces_tool" "ces_tool_google_search_tool_basic" {
    location       = "us"
    app            = google_ces_app.my-app.name
    tool_id        = "ces_tool_basic3-${local.name_suffix}"
    execution_type = "SYNCHRONOUS"
    google_search_tool {
        name            = "example-tool"
        context_urls    = ["example.com", "example2.com"]
        description     = "example-description"
        exclude_domains = ["example.com", "example2.com"]
        preferred_domains = ["example3.com", "example4.com"]
    }
}
