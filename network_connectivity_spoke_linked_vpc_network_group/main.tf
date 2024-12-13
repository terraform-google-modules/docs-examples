resource "google_compute_network" "network" {
  name                    = "net-spoke-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_connectivity_hub" "basic_hub" {
  name        = "hub1-spoke-${local.name_suffix}"
  description = "A sample hub"
  labels = {
    label-two = "value-one"
  }
}

resource "google_network_connectivity_group" "default_group"  {
 hub         = google_network_connectivity_hub.basic_hub.id
 name        = "default"
 description = "A sample hub group"
}

resource "google_network_connectivity_spoke" "primary"  {
  name = "group-spoke1-${local.name_suffix}"
  location = "global"
  description = "A sample spoke with a linked VPC"
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
  group = google_network_connectivity_group.default_group.id
}
