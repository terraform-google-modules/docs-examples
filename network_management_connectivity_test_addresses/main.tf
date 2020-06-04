resource "google_network_management_connectivity_test" "address-test" {
  name = "conn-test-addr-${local.name_suffix}"
  source {
      ip_address = google_compute_address.source-addr.address
      project_id = google_compute_address.source-addr.project
      network = google_compute_network.vpc.id
      network_type = "GCP_NETWORK"
  }

  destination {
      ip_address = google_compute_address.dest-addr.address
      project_id = google_compute_address.dest-addr.project
      network = google_compute_network.vpc.id
  }

  protocol = "UDP"
}

resource "google_compute_network" "vpc" {
  name = "connectivity-vpc-${local.name_suffix}"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "connectivity-vpc-${local.name_suffix}-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}

resource "google_compute_address" "source-addr" {
  name         = "src-addr-${local.name_suffix}"
  subnetwork   = google_compute_subnetwork.subnet.id
  address_type = "INTERNAL"
  address      = "10.0.42.42"
  region       = "us-central1"
}

resource "google_compute_address" "dest-addr" {
  name         = "dest-addr-${local.name_suffix}"
  subnetwork   = google_compute_subnetwork.subnet.id
  address_type = "INTERNAL"
  address      = "10.0.43.43"
  region       = "us-central1"
}
