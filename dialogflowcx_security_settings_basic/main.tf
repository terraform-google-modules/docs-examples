resource "google_dialogflow_cx_security_settings" "basic_security_settings" {
  display_name          = "dialogflowcx-security-settings-${local.name_suffix}"
  location              = "global"
  purge_data_types      = []
  retention_window_days = 7
}
