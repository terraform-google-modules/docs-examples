resource "google_network_services_gateway" "default" {
  name     = "my-gateway-${local.name_suffix}"
  scope    = "default-scope-basic"
  type     = "OPEN_MESH"
  ports    = [443]
}
