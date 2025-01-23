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
  name = "spoke1-ipv6-${local.name_suffix}"
  location = "global"
  description = "A sample spoke with a linked VPC that include export ranges of all IPv6"
  labels = {
    label-one = "value-one"
  }
  hub = google_network_connectivity_hub.basic_hub.id
  linked_vpc_network {
    include_export_ranges = [
      "ALL_IPV6_RANGES",
      "ALL_PRIVATE_IPV4_RANGES"
    ]
    uri = google_compute_network.network.self_link
  }
}
