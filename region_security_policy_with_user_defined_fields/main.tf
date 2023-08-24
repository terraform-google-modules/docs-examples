resource "google_compute_region_security_policy" "region-sec-policy-user-defined-fields" {
  provider    = google-beta  

  name        = "my-sec-policy-user-defined-fields-${local.name_suffix}"
  description = "with user defined fields"
  type        = "CLOUD_ARMOR_NETWORK"
  user_defined_fields {
    name = "SIG1_AT_0"
    base = "UDP"
    offset = 8
    size = 2
    mask = "0x8F00"
  }
  user_defined_fields {
    name = "SIG2_AT_8"
    base = "UDP"
    offset = 16
    size = 4
    mask = "0xFFFFFFFF"
  }
}
