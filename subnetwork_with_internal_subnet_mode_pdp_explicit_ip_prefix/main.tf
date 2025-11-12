resource "google_compute_subnetwork" "subnetwork-with-internal-subnet-mode-pdp-explicit-ip-prefix" {
  name             = "subnet-mode-pdp-subnet-internal-prefix-${local.name_suffix}"
  region           = "us-central1"
  network          = google_compute_network.custom-test-network.id
  stack_type       = "IPV6_ONLY"
  ipv6_access_type = "INTERNAL"
  ip_collection    = ""projects/tf-static-byoip/regions/us-central1/publicDelegatedPrefixes/internal-ipv6-subnet-mode-test-sub-pdp-explicit-prefix"-${local.name_suffix}"
  internal_ipv6_prefix = ""2001:db8:1::/64"-${local.name_suffix}"
}

resource "google_compute_network" "custom-test-network" {
  name                    = "network-byoipv6-internal-prefix-${local.name_suffix}"
  auto_create_subnetworks = false
}
