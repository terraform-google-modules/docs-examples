resource "google_network_services_endpoint_policy" "default" {
  provider               = google-beta
  name                   = "my-endpoint-policy-${local.name_suffix}"
  labels                 = {
    foo = "bar"
  }
  description            = "my description"
  type                   = "SIDECAR_PROXY"
  traffic_port_selector {
    ports = ["8081"]
  }
  endpoint_matcher {
    metadata_label_matcher {
      metadata_label_match_criteria = "MATCH_ANY"
    }
  }
}
  
