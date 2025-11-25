resource "google_network_services_multicast_domain_group" "mdg_test"{
  multicast_domain_group_id                    = "test-mdg-resource-${local.name_suffix}"
  location = "global"
  description = "my description"
  labels = {
    fake_label = "label123"
  }
}

resource "google_compute_network" "network" {
  name                    = "test-mdg-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_services_multicast_domain" "multicast_domain_a" {
  multicast_domain_id                    = "test-mdg-domain-a-${local.name_suffix}"
  location = "global"
  admin_network = google_compute_network.network.id
  connection_config  { connection_type="SAME_VPC"}
  multicast_domain_group = google_network_services_multicast_domain_group.mdg_test.id
  depends_on = [google_compute_network.network]
}

resource "google_network_services_multicast_domain" "multicast_domain_b" {
  multicast_domain_id                   = "test-mdg-domain-b-${local.name_suffix}"
  location = "global"
  admin_network = google_compute_network.network.id
  connection_config  { connection_type="SAME_VPC"}
  multicast_domain_group = google_network_services_multicast_domain_group.mdg_test.id
  depends_on = [google_compute_network.network]
}
