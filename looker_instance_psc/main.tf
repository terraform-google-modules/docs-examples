resource "google_looker_instance" "looker-instance" {
  name               = "my-instance-${local.name_suffix}"
  platform_edition   = "LOOKER_CORE_ENTERPRISE_ANNUAL"
  region             = "us-central1"
  private_ip_enabled = false
  public_ip_enabled  = false
  psc_enabled        = true
  oauth_config {
    client_id = "my-client-id-${local.name_suffix}"
    client_secret = "my-client-secret-${local.name_suffix}"
  }
  psc_config {
    allowed_vpcs = ["projects/test-project/global/networks/test"]
    # update only
    # service_attachments = [{local_fqdn: "www.local-fqdn.com" target_service_attachment_uri: "projects/my-project/regions/us-east1/serviceAttachments/sa"}]
  }
}
