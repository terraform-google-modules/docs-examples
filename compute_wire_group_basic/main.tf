data "google_project" "project" {
}

resource "google_compute_cross_site_network" "example-cross-site-network" {
  name        = "test-cross-site-network-${local.name_suffix}"
  description = "Example cross site network"
}

resource "google_compute_wire_group" "example-test-wire-group" {
  name               = "test-wire-group-${local.name_suffix}"
  description        = "Example Wire Group-${local.name_suffix}"
  cross_site_network = "test-cross-site-network-${local.name_suffix}"
  depends_on = [
    google_compute_cross_site_network.example-cross-site-network
  ]
  wire_properties {
    bandwidth_unmetered = 10
    fault_response =  "NONE"
    bandwidth_allocation = "ALLOCATE_PER_WIRE"
  }
  admin_enabled = true
}
