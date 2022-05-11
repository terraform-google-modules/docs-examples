resource "google_compute_region_network_endpoint_group" "psc_neg" {
  name                  = "psc-neg-${local.name_suffix}"
  region                = "asia-northeast3"

  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = "asia-northeast3-cloudkms.googleapis.com"
}
