resource "google_ces_app" "my-app" {
    location     = "us"
    display_name = "my-app-${local.name_suffix}"
    app_id       = "app-id-${local.name_suffix}"
    time_zone_settings {   
        time_zone = "America/Los_Angeles"
    }
}
resource "google_ces_app_version" "my-app-version" {
    location       = "us"
    display_name   = "my-app-version-${local.name_suffix}"
    app            = google_ces_app.my-app.name
    app_version_id = "app-version-id-${local.name_suffix}"
    description    = "example-app-version"
}
resource "google_ces_deployment" "my-deployment" {
    location     = "us"
    display_name = "my-deployment-${local.name_suffix}"
    app          = google_ces_app.my-app.name
    app_version  = google_ces_app_version.my-app-version.id
    channel_profile {
        channel_type = "API"
        disable_barge_in_control = true
        disable_dtmf = true
        persona_property {
            persona = "CHATTY"
        }
        profile_id = "temp_profile_id"
        web_widget_config {
            modality = "CHAT_AND_VOICE"
            theme = "DARK"
            web_widget_title = "temp_webwidget_title"
        }
    }
}
