resource "google_compute_region_security_policy" "region-sec-policy-ddos-protection" {
  name        = "my-sec-policy-ddos-protection-${local.name_suffix}"
  description = "with ddos protection config"
  type        = "CLOUD_ARMOR_NETWORK"

  ddos_protection_config {
    ddos_protection = "ADVANCED_PREVIEW"
  }
}
