resource "google_compute_network" "network" {
  name                    = "net-spoke-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "address" {
  name          = "test-address-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.network.id
}

resource "google_service_networking_connection" "peering" {
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.address.name]
}

resource "google_network_connectivity_hub" "basic_hub" {
  name = "hub-basic-${local.name_suffix}"
}

resource "google_network_connectivity_spoke" "linked_vpc_spoke"  {
  name     = "vpc-spoke-${local.name_suffix}"
  location = "global"
  hub      = google_network_connectivity_hub.basic_hub.id
  linked_vpc_network {
    uri = google_compute_network.network.self_link
  }
}

resource "google_network_connectivity_spoke" "primary"  {
  name        = "producer-spoke-${local.name_suffix}"
  location    = "global"
  description = "A sample spoke with a linked router appliance instance"
  labels = {
    label-one = "value-one"
  }
  hub         = google_network_connectivity_hub.basic_hub.id
  linked_producer_vpc_network {
    network = google_compute_network.network.name
    peering = google_service_networking_connection.peering.peering
    exclude_export_ranges = [
    "198.51.100.0/24",
    "10.10.0.0/16"
    ]
  }
  depends_on  = [google_network_connectivity_spoke.linked_vpc_spoke]
}
