resource "google_compute_subnetwork" "subnetwork-cidr-overlap" {

  name                             = "subnet-cidr-overlap-${local.name_suffix}"
  region                           = "us-west2"
  ip_cidr_range                    = "192.168.1.0/24"
  allow_subnet_cidr_routes_overlap = true
  network                          = google_compute_network.net-cidr-overlap.id
}

resource "google_compute_network" "net-cidr-overlap" {

  name                    = "net-cidr-overlap-${local.name_suffix}"
  auto_create_subnetworks = false
}
