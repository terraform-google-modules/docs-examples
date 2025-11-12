resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {
        time_zone = "America/Los_Angeles"
    }
}

resource "google_ces_example" "my-example" {
    location     = "us"
    display_name = "my-example-${local.name_suffix}"
    app          = google_ces_app.my-app.name
    example_id   = "example-id-${local.name_suffix}"
    description  = "example description"
    messages {
        chunks {
            image {
                mime_type = "image/png"
                data = base64encode("This is some fake image binary data.")
            }
        }
        chunks {
            text = "text_data"
        }
        chunks {
            updated_variables = jsonencode({
                var1 = "val1"
                var2 = "val2"
            })
        }
        role = "agent"
    }
}
