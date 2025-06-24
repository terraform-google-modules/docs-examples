resource "google_compute_network" "network" {
  name                    = "example-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_security_intercept_deployment_group" "default" {
  intercept_deployment_group_id = "example-dg-${local.name_suffix}"
  location                      = "global"
  network                       = google_compute_network.network.id
  description                   = "some description"
  labels = {
    foo = "bar"
  }
}
