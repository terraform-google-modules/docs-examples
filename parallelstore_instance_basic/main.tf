resource "google_parallelstore_instance" "instance" {
  instance_id = "instance-${local.name_suffix}"
  location = "us-central1-a"
  description = "test instance"
  capacity_gib = 12000
  network = google_compute_network.network.name
  file_stripe_level = "FILE_STRIPE_LEVEL_MIN"
  directory_stripe_level = "DIRECTORY_STRIPE_LEVEL_MIN"
deployment_type = "SCRATCH"
  labels = {
    test = "value"
  }
  depends_on = [google_service_networking_connection.default]
}

resource "google_compute_network" "network" {
  name                    = "network-${local.name_suffix}"
  auto_create_subnetworks = true
  mtu = 8896
}

# Create an IP address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "address-${local.name_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.network.id
}

# Create a private connection
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}
