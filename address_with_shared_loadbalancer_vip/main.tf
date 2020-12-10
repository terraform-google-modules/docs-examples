resource "google_compute_address" "internal_with_shared_loadbalancer_vip" {
  name         = "my-internal-address-${local.name_suffix}"
  address_type = "INTERNAL"
  purpose      = "SHARED_LOADBALANCER_VIP"
}
