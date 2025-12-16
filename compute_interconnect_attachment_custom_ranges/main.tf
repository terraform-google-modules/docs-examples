resource "google_compute_interconnect_attachment" "custom-ranges-interconnect-attachment" {
  name                                   = "test-custom-ranges-interconnect-attachment-${local.name_suffix}"
  edge_availability_domain               = "AVAILABILITY_DOMAIN_1"
  type                                   = "PARTNER"
  router                                 = google_compute_router.foobar.id
  mtu                                    = 1500
  stack_type                             = "IPV4_IPV6"
  labels                                 = { mykey = "myvalue" }
  candidate_cloud_router_ip_address      = "192.169.0.1/29"
  candidate_customer_router_ip_address   = "192.169.0.2/29"
  candidate_cloud_router_ipv6_address    = "748d:2f23:6651:9455:828b:ca81:6fe0:fed1/125"
  candidate_customer_router_ipv6_address = "748d:2f23:6651:9455:828b:ca81:6fe0:fed2/125"
}

resource "google_compute_router" "foobar" {
  name     = "test-router-${local.name_suffix}"
  network  = google_compute_network.foobar.name
  bgp {
    asn = 16550
  }
}

resource "google_compute_network" "foobar" {
  name                    = "test-network-${local.name_suffix}"
  auto_create_subnetworks = false
}
