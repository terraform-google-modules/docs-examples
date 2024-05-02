resource "google_compute_network" "my_network" {
  name                    = "my-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name          = "my-subnetwork-${local.name_suffix}"
  ip_cidr_range = "192.168.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.my_network.id
}

resource "google_network_connectivity_regional_endpoint" "default" {
  name              = "my-rep-${local.name_suffix}"
  location          = "us-central1"
  target_google_api = "boqcodelabjaimin-pa.us-central1.p.rep.googleapis.com"
  access_type       = "REGIONAL"
  address           = "192.168.0.5"
  network           = google_compute_network.my_network.id
  subnetwork        = google_compute_subnetwork.my_subnetwork.id
  description       = "My RegionalEndpoint targeting Google API boqcodelabjaimin-pa.us-central1.p.rep.googleapis.com"
  labels            = {env = "default"}
}
