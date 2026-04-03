resource "google_compute_subnetwork" "subnetwork-resolve-subnet-mask" {

  name             = "subnet-resolve-subnet-mask-test-subnetwork-${local.name_suffix}"
  region           = "us-west2"
  ip_cidr_range    = "10.10.0.0/24"
  purpose          = "PRIVATE"
  resolve_subnet_mask = "ARP_PRIMARY_RANGE"
  network          = google_compute_network.custom-test.id
}

resource "google_compute_network" "custom-test" {

  name                    = "subnet-resolve-subnet-mask-test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
