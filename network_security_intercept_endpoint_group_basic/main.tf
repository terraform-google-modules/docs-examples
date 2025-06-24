resource "google_compute_network" "network" {
  name                    = "example-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_security_intercept_deployment_group" "deployment_group" {
  intercept_deployment_group_id = "example-dg-${local.name_suffix}"
  location                      = "global"
  network                       = google_compute_network.network.id
}

resource "google_network_security_intercept_endpoint_group" "default" {
  intercept_endpoint_group_id = "example-eg-${local.name_suffix}"
  location                    = "global"
  intercept_deployment_group  = google_network_security_intercept_deployment_group.deployment_group.id
  description                 = "some description"
  labels = {
    foo = "bar"
  }
}
