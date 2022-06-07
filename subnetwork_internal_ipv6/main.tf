resource "google_compute_subnetwork" "subnetwork-internal-ipv6" {
  name          = "internal-ipv6-test-subnetwork-${local.name_suffix}"
  
  ip_cidr_range = "10.0.0.0/22"
  region        = "us-west2"
  
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "INTERNAL"

  network       = google_compute_network.custom-test.id
}

resource "google_compute_network" "custom-test" {
  name                    = "internal-ipv6-test-network-${local.name_suffix}"
  auto_create_subnetworks = false
  enable_ula_internal_ipv6 = true
}
