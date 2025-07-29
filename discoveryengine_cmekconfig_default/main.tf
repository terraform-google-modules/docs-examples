resource "google_discovery_engine_cmek_config" "default" {
  location            = "us"
  cmek_config_id      = "cmek-config-id-${local.name_suffix}"
  kms_key             = "kms-key-name-${local.name_suffix}"
}
