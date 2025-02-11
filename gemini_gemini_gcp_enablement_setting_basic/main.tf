resource "google_gemini_gemini_gcp_enablement_setting" "example" {
    gemini_gcp_enablement_setting_id = "ls1-tf-${local.name_suffix}"
    location = "global"
    enable_customer_data_sharing = true
}
