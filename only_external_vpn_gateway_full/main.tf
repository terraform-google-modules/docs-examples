resource "google_compute_external_vpn_gateway" "external_gateway" {
  name            = "external-gateway-${local.name_suffix}"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "An externally managed VPN gateway"
  interface {
    id         = 0
    ip_address = "8.8.8.8"
  }
  labels = {
    key = "value"
    otherkey = ""
  }
}
