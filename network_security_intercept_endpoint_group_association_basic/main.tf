resource "google_compute_network" "producer_network" {
  name                    = "example-prod-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_compute_network" "consumer_network" {
  name                    = "example-cons-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_security_intercept_deployment_group" "deployment_group" {
  intercept_deployment_group_id = "example-dg-${local.name_suffix}"
  location                      = "global"
  network                       = google_compute_network.producer_network.id
}

resource "google_network_security_intercept_endpoint_group" "endpoint_group" {
  intercept_endpoint_group_id = "example-eg-${local.name_suffix}"
  location                    = "global"
  intercept_deployment_group  = google_network_security_intercept_deployment_group.deployment_group.id
}

resource "google_network_security_intercept_endpoint_group_association" "default" {
  intercept_endpoint_group_association_id = "example-ega-${local.name_suffix}"
  location                                = "global"
  network                                 = google_compute_network.consumer_network.id
  intercept_endpoint_group                = google_network_security_intercept_endpoint_group.endpoint_group.id
  labels = {
    foo = "bar"
  }
}
