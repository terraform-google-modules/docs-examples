resource "google_certificate_manager_certificate_map" "default" {
  name        = "cert-map-${local.name_suffix}"
  description = "My acceptance test certificate map"
  labels      = {
    "terraform" : true,
    "acc-test"  : true,
  }
}
