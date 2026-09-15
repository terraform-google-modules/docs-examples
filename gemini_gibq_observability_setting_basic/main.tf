resource "google_gemini_gibq_observability_setting" "example" {
    gibq_observability_setting_id = "ls-tf1-${local.name_suffix}"
    location = "global"
    labels = {"my_key": "my_value"}
    conversational_analytics_setting {}
}
