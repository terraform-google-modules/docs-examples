resource "google_compute_network_peering_routes_config" "peering_primary_routes" {
  peering = google_compute_network_peering.peering_primary.name
  network = google_compute_network.network_primary.name

  import_custom_routes = true
  export_custom_routes = true
}

resource "google_compute_network_peering" "peering_primary" {
  name         = "primary-peering-${local.name_suffix}"
  network      = google_compute_network.network_primary.id
  peer_network = google_compute_network.network_secondary.id

  import_custom_routes = true
  export_custom_routes = true
}

resource "google_compute_network_peering" "peering_secondary" {
  name         = "secondary-peering-${local.name_suffix}"
  network      = google_compute_network.network_secondary.id
  peer_network = google_compute_network.network_primary.id
}

resource "google_compute_network" "network_primary" {
  name                    = "primary-network-${local.name_suffix}"
  auto_create_subnetworks = "false"
}

resource "google_compute_network" "network_secondary" {
  name                    = "secondary-network-${local.name_suffix}"
  auto_create_subnetworks = "false"
}
