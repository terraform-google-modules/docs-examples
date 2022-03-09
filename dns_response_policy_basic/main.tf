resource "google_compute_network" "network-1" {
  provider = google-beta

  name                    = "network-1-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_network" "network-2" {
  provider = google-beta
  
  name                    = "network-2-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_dns_response_policy" "example-response-policy" {
  provider = google-beta
  
  response_policy_name = "example-response-policy-${local.name_suffix}"
  
  networks {
    network_url = google_compute_network.network-1.id
  }
  networks {
    network_url = google_compute_network.network-2.id
  }
}
