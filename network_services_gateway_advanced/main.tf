resource "google_network_services_gateway" "default" {
  name        = "my-gateway-${local.name_suffix}"
  labels      = {
    foo = "bar"
  }
  description = "my description"
  type        = "OPEN_MESH"
  ports       = [443]
  scope       = "default-scope-advance"
}
