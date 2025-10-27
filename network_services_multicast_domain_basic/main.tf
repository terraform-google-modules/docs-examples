resource "google_compute_network" "network" {
  name                    = "test-md-network-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_services_multicast_domain" md_test {
  multicast_domain_id = "test-md-domain-${local.name_suffix}"
  location = "global"
  description = "A sample domain"
  labels = {
    label-one = "value-one"
  }
  admin_network = google_compute_network.network.id
  connection_config  { 
    connection_type = "SAME_VPC"
    ncc_hub = ""
  }
  multicast_domain_group  = ""
  depends_on = [google_compute_network.network]
}
