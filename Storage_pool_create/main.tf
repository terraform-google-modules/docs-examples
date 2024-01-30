# Create a network or use datasource to reference existing network
resource "google_compute_network" "peering_network" {
  name = "test-network-${local.name_suffix}"
}

# Reserve a CIDR for NetApp Volumes to use
# When using shared-VPCs, this resource needs to be created in host project
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "test-address-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.peering_network.id
}

# Create a Private Service Access connection
# When using shared-VPCs, this resource needs to be created in host project
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.peering_network.id
  service                 = "netapp.servicenetworking.goog"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

# Modify the PSA Connection to allow import/export of custom routes
# When using shared-VPCs, this resource needs to be created in host project
resource "google_compute_network_peering_routes_config" "route_updates" {
  peering = google_service_networking_connection.default.peering
  network = google_compute_network.peering_network.name

  import_custom_routes = true
  export_custom_routes = true
}

# Create a storage pool
# Create this resource in the project which is expected to own the volumes
resource "google_netapp_storage_pool" "test_pool" {
  name = "test-pool-${local.name_suffix}"
  # project = <your_project>
  location = "us-central1"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = google_compute_network.peering_network.id
}
