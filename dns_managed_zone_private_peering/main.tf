resource "google_dns_managed_zone" "peering-zone" {
  provider = "google-beta"

  name = "peering-zone-${local.name_suffix}"
  dns_name = "peering.example.com."
  description = "Example private DNS peering zone"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url =  "${google_compute_network.network-source.self_link}"
    }
  }

  peering_config {
    target_network {
      network_url = "${google_compute_network.network-target.self_link}"
    }
  }
}

resource "google_compute_network" "network-source" {
  provider = "google-beta"

  name = "network-source-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_network" "network-target" {
  provider = "google-beta"

  name = "network-target-${local.name_suffix}"
  auto_create_subnetworks = false
}

provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-a"
}
