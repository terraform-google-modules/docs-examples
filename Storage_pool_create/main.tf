data "google_compute_network" "default" {
  name = "test-network-${local.name_suffix}"
}

# Create a storage pool
# Create this resource in the project which is expected to own the volumes
resource "google_netapp_storage_pool" "test_pool" {
  name = "test-pool-${local.name_suffix}"
  # project = <your_project>
  location = "us-central1"
  service_level = "PREMIUM"
  capacity_gib = "2048"
  network = data.google_compute_network.default.id
}
