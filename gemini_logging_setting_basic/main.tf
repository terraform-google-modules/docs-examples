resource "google_gemini_logging_setting" "example" {
    logging_setting_id = "ls1-tf-${local.name_suffix}"
    location = "global"
    labels = {"my_key": "my_value"}
    log_prompts_and_responses = true
    log_metadata = true
}
