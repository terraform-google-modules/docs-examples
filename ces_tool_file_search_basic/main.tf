resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {   
        time_zone = "America/Los_Angeles"
    }
}

resource "google_ces_tool" "ces_tool_file_search_basic" {
    location       = "us"
    app            = google_ces_app.my-app.name
    tool_id        = "ces_tool_basic6-${local.name_suffix}"
    execution_type = "SYNCHRONOUS"
    file_search_tool {
        name        = "ces_tool_file_search_basic-${local.name_suffix}"
        description = "example-description"
        corpus_type = "FULLY_MANAGED"
        file_corpus = "projects/${google_ces_app.my-app.project}/locations/us/ragCorpora/tf-test-mock-corpus"
    }
}
