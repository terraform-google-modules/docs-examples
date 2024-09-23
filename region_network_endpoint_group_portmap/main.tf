resource "google_compute_region_network_endpoint_group" "region_network_endpoint_group_portmap" {
  name                  = "portmap-neg-${local.name_suffix}"
  region                = "us-central1"
  network               = google_compute_network.default.id
  subnetwork            = google_compute_subnetwork.default.id

  network_endpoint_type = "GCE_VM_IP_PORTMAP"
}

resource "google_compute_network" "default" {
  name                    = "network-${local.name_suffix}"
}

resource "google_compute_subnetwork" "default" {
  name          = "subnetwork-${local.name_suffix}"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.default.id
}
