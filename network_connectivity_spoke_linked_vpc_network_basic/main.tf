resource "google_compute_network" "network" {
  name                    = "net-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_connectivity_hub" "basic_hub" {
  name        = "hub1-${local.name_suffix}"
  description = "A sample hub"
  labels = {
    label-two = "value-one"
  }
}

resource "google_network_connectivity_spoke" "primary"  {
  name = "spoke1-${local.name_suffix}"
  location = "global"
  description = "A sample spoke with a linked router appliance instance"
  labels = {
    label-one = "value-one"
  }
  hub = google_network_connectivity_hub.basic_hub.id
  linked_vpc_network {
    exclude_export_ranges = [
      "198.51.100.0/24",
      "10.10.0.0/16"
    ]
    include_export_ranges = [
      "198.51.100.0/23", 
      "10.0.0.0/8"
    ]
    uri = google_compute_network.network.self_link
  }
}
