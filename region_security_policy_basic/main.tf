resource "google_compute_region_security_policy" "region-sec-policy-basic" {
  provider    = google-beta

  name        = "my-sec-policy-basic-${local.name_suffix}"
  description = "basic region security policy"
  type        = "CLOUD_ARMOR"
}
