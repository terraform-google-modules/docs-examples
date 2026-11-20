resource "google_compute_global_address" "default" {
  name          = "global-psc-ir-ip-${local.name_suffix}"
  address_type  = "INTERNAL"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  network       = google_compute_network.network.id
  address       = "10.0.0.5"
  ip_collection = google_network_connectivity_internal_range.range.id
}

resource "google_network_connectivity_internal_range" "range" {
  name          = "psc-internal-range-${local.name_suffix}"
  network       = google_compute_network.network.self_link
  usage         = "FOR_VPC"
  peering       = "FOR_SELF"
  purpose       = "INTERNAL_ADDRESS"
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_network" "network" {
  name                    = "my-network-name-${local.name_suffix}"
  auto_create_subnetworks = false
}
