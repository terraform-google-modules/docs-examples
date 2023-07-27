resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con-${local.name_suffix}"
  subnet {
    name = google_compute_subnetwork.custom_test.name
  }
  machine_type = "e2-standard-4"
}

resource "google_compute_subnetwork" "custom_test" {
  name          = "vpc-con-${local.name_suffix}"
  ip_cidr_range = "10.2.0.0/28"
  region        = "us-central1"
  network       = google_compute_network.custom_test.id
}

resource "google_compute_network" "custom_test" {
  name                    = "vpc-con-${local.name_suffix}"
  auto_create_subnetworks = false
}
