resource "google_dns_managed_zone" "private-zone" {
  name        = "private-zone-${local.name_suffix}"
  dns_name    = "private.example.com."
  description = "Example private DNS zone"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.network_1.id
    }
  }

  forwarding_config {
    target_name_servers {
      ipv6_address = "fd20:3e9:7a70:680d:0:8::"
    }
  }
}

resource "google_compute_network" "network_1" {
  name                    = "network-1-${local.name_suffix}"
  auto_create_subnetworks = false
}
