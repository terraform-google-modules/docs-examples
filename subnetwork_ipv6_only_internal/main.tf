resource "google_compute_subnetwork" "subnetwork-ipv6-only" {
  name          = "subnet-ipv6-only-${local.name_suffix}"
  region        = "us-central1"
  network       = google_compute_network.custom-test.id
  stack_type    = "IPV6_ONLY"
  ipv6_access_type = "INTERNAL"
}

resource "google_compute_network" "custom-test" {
  name                    = "network-ipv6-only-${local.name_suffix}"
  auto_create_subnetworks = false
  enable_ula_internal_ipv6 = true
}
