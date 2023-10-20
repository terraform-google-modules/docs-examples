resource "google_network_connectivity_policy_based_route" "default" {
  name = "my-pbr-${local.name_suffix}"
  network = google_compute_network.my_network.id
  filter {
    protocol_version = "IPV4"
  }
  next_hop_other_routes = "DEFAULT_ROUTING"
}

resource "google_compute_network" "my_network" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
