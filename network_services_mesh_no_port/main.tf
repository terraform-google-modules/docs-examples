resource "google_network_services_mesh" "default" {
  name        = "my-mesh-noport-${local.name_suffix}"
  labels      = {
    foo = "bar"
  }
  description = "my description"
}
