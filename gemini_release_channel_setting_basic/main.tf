resource "google_gemini_release_channel_setting" "example" {
    release_channel_setting_id = "ls1-tf-${local.name_suffix}"
    location = "global"
    labels = {"my_key": "my_value"}
    release_channel = "EXPERIMENTAL"
}
