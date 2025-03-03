resource "google_network_services_mesh" "default" {
  name        = "my-mesh-${local.name_suffix}"
  location    = "global"
}
