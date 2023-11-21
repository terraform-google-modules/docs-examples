
resource "google_compute_network" "peering_network" {
  name = "test-network-${local.name_suffix}"
}

# Create an IP address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "test-address-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.peering_network.id
}

# Create a private connection
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.peering_network.id
  service                 = "netapp.servicenetworking.goog"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "google_netapp_storage_pool" "test_pool" {
  name = "test-pool-${local.name_suffix}"
  location = "us-central1"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = google_compute_network.peering_network.id
}
