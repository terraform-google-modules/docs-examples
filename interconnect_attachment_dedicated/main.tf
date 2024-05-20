data "google_project" "project" {}

resource "google_compute_interconnect" "foobar" {
  name                 = "interconenct-1-${local.name_suffix}"
  customer_name        = "internal_customer" # Special customer only available for Google testing.
  interconnect_type    = "IT_PRIVATE"        # Special type only available for Google testing.
  link_type            = "LINK_TYPE_ETHERNET_10G_LR"
  requested_link_count = 1
  location             = "https://www.googleapis.com/compute/v1/projects/${data.google_project.project.name}/global/interconnectLocations/z2z-us-east4-zone1-lciadl-a" # Special location only available for Google testing.
}

resource "google_compute_interconnect_attachment" "on_prem" {
  name                     = "on-prem-attachment-${local.name_suffix}"
  type                     = "DEDICATED"
  interconnect             = google_compute_interconnect.foobar.id
  router                   = google_compute_router.foobar.id
  mtu                      = 1500
  subnet_length            = 29
  vlan_tag8021q            = 1000
  region                   = "https://www.googleapis.com/compute/v1/projects/${data.google_project.project.name}/regions/us-east4"
  stack_type               = "IPV4_ONLY"
}

resource "google_compute_router" "foobar" {
  name    = "router-1-${local.name_suffix}"
  network = google_compute_network.foobar.name
  region  = "us-east4"
  bgp {
    asn = 16550
  }
}

resource "google_compute_network" "foobar" {
  name                    = "network-1-${local.name_suffix}"
  auto_create_subnetworks = false
}
