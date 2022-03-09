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

resource "google_dns_response_policy" "response-policy" {
  provider = google-beta

  response_policy_name = "example-response-policy-${local.name_suffix}"
  
  networks {
    network_url = google_compute_network.network-1.id
  }
  networks {
    network_url = google_compute_network.network-2.id
  }
}

resource "google_dns_response_policy_rule" "example-response-policy-rule" {
  provider = google-beta

  response_policy = google_dns_response_policy.response-policy.response_policy_name
  rule_name       = "example-rule-${local.name_suffix}"
  dns_name        = "dns.example.com."

  local_data {
    local_datas {
      name    = "dns.example.com."
      type    = "A"
      ttl     = 300
      rrdatas = ["192.0.2.91"]
    }
  }  

}
