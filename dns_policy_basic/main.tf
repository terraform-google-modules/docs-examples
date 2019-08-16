resource "google_dns_policy" "example-policy" {
  provider = "google-beta"

  name = "example-policy-${local.name_suffix}"
  enable_inbound_forwarding = true

  enable_logging = true

  alternative_name_server_config {
    target_name_servers {
      ipv4_address = "172.16.1.10"
    }
    target_name_servers {
      ipv4_address = "172.16.1.20"
    }
  }

  networks {
    network_url =  "${google_compute_network.network-1.self_link}"
  }
  networks {
    network_url =  "${google_compute_network.network-2.self_link}"
  }
}

resource "google_compute_network" "network-1" {
  provider = "google-beta"

  name = "network-1-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_network" "network-2" {
  provider = "google-beta"

  name = "network-2-${local.name_suffix}"
  auto_create_subnetworks = false
}

provider "google-beta"{
  region = "us-central1"
  zone   = "us-central1-a"
}
