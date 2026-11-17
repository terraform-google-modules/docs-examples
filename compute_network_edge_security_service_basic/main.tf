resource "google_compute_network_edge_security_service" "default" {
  name         = "my-edge-security-service-${local.name_suffix}"
  region       = "us-east1"
  description  = "My basic resource"
}
