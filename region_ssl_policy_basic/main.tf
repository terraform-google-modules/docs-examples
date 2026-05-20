resource "google_compute_region_ssl_policy" "region-ssl-policy" {
  name    = "region-ssl-policy-${local.name_suffix}"
  region  = "us-central1"
  profile = "MODERN"
}
