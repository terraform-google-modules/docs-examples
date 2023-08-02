resource "google_compute_network" "producer_net" {
  name                    = "producer-net-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "producer_subnet" {
  name          = "producer-subnet-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.producer_net.id
}

resource "google_network_connectivity_service_connection_policy" "default" {
  name = "my-network-connectivity-policy-${local.name_suffix}"
  location = "us-central1"
  service_class = "my-basic-service-class-${local.name_suffix}"
  description   = "my basic service connection policy"
  network = google_compute_network.producer_net.id
  psc_config {
    subnetworks = [google_compute_subnetwork.producer_subnet.id]
    limit = 2
  }
}
