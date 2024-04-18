resource "google_network_connectivity_internal_range" "default" {
  name    = "external-ranges-${local.name_suffix}"
  network = google_compute_network.default.id
  usage   = "EXTERNAL_TO_VPC"
  peering = "FOR_SELF"
  ip_cidr_range = "172.16.0.0/24"

  labels  = {
    external-reserved-range: "on-premises"
  }
}

resource "google_compute_network" "default" {
  name                    = "internal-ranges-${local.name_suffix}"
  auto_create_subnetworks = false
}
