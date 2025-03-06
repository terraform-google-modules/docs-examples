resource "google_compute_subnetwork" "subnetwork-with-subnet-mode-pdp" {
  name             = "subnet-mode-pdp-subnet-${local.name_suffix}"
  region           = "us-central1"
  network          = google_compute_network.custom-test-network.id
  stack_type       = "IPV6_ONLY"
  ipv6_access_type = "EXTERNAL"
  ip_collection    = ""projects/tf-static-byoip/regions/us-central1/publicDelegatedPrefixes/tf-test-subnet-mode-pdp"-${local.name_suffix}"
}

resource "google_compute_network" "custom-test-network" {
  name                    = "network-byoipv6-external-${local.name_suffix}"
  auto_create_subnetworks = false
}
