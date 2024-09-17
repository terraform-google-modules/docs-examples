resource "google_looker_instance" "looker-instance" {
  name               = "my-instance-fips-${local.name_suffix}"
  platform_edition   = "LOOKER_CORE_ENTERPRISE_ANNUAL"
  region             = "us-central1"
  public_ip_enabled  = true
  fips_enabled = true
  oauth_config {
    client_id = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }  
}
