resource "google_compute_subnetwork" "subnetwork-with-internal-subnet-mode-pdp" {
  name             = "internal-subnet-mode-pdp-subnet-${local.name_suffix}"
  region           = "us-central1"
  network          = google_compute_network.custom-test-network.id
  stack_type       = "IPV6_ONLY"
  ipv6_access_type = "INTERNAL"
  ip_collection    = ""projects/tf-static-byoip/regions/us-central1/publicDelegatedPrefixes/internal-ipv6-subnet-mode-test-sub-pdp"-${local.name_suffix}"
}

resource "google_compute_network" "custom-test-network" {
  name                    = "network-byoipv6-internal-${local.name_suffix}"
  auto_create_subnetworks = false
}
