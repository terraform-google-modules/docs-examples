resource "google_looker_instance" "looker-instance" {
  name              = "my-instance-${local.name_suffix}"
  platform_edition  = "LOOKER_CORE_STANDARD_ANNUAL"
  region            = "us-central1"
  oauth_config {
    client_id = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }
}
