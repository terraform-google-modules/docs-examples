resource "google_compute_address" "internal_with_gce_endpoint" {
  name         = "my-internal-address--${local.name_suffix}"
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
}
