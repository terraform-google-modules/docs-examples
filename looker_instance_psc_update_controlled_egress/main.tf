provider "google" {
  prefer_regional_endpoints = true
}

resource "google_looker_instance" "looker-instance" {
  name              = "my-instance-${local.name_suffix}"
  platform_edition  = "LOOKER_CORE_ENTERPRISE_ANNUAL"
  region            = "us-central1"
  public_ip_enabled = true
  psc_enabled       = true

  psc_config {
    allowed_vpcs = []
  }

  controlled_egress_enabled = true

  controlled_egress_config {
    marketplace_enabled = true
    egress_fqdns        = ["google.com", "github.com"]
  }

  oauth_config {
    client_id     = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }
}
