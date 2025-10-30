data "google_project" "project" {
}

resource "google_network_management_vpc_flow_logs_config" "network-test" {
  vpc_flow_logs_config_id = "basic-network-test-id-${local.name_suffix}"
  location                = "global"
  network                 = "projects/${data.google_project.project.number}/global/networks/${google_compute_network.network.name}"
}

resource "google_compute_network" "network" {
  name     = "basic-network-test-network-${local.name_suffix}"
}
