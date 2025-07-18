resource "google_gemini_gemini_gcp_enablement_setting" "example" {
    gemini_gcp_enablement_setting_id = "ls1-tf-${local.name_suffix}"
    location = "global"
    labels = {"my_key": "my_value"}
    enable_customer_data_sharing = true
    web_grounding_type = "WEB_GROUNDING_FOR_ENTERPRISE"
}
