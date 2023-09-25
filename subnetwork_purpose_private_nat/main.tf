resource "google_compute_subnetwork" "subnetwork-purpose-private-nat" {
  provider         = google-beta

  name             = "subnet-purpose-test-subnetwork-${local.name_suffix}"
  region           = "us-west2"
  ip_cidr_range    = "192.168.1.0/24"
  purpose          = "PRIVATE_NAT"
  network          = google_compute_network.custom-test.id
}

resource "google_compute_network" "custom-test" {
  provider                = google-beta

  name                    = "subnet-purpose-test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
