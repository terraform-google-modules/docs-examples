resource "google_compute_network" "network" {
  name                    = "test-network-mca-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_services_multicast_domain" "multicast_domain" {
  multicast_domain_id                    = "test-domain-mca-${local.name_suffix}"
  location = "global"
  admin_network = google_compute_network.network.id
  connection_config  { connection_type="SAME_VPC"}
  depends_on = [google_compute_network.network]
}

resource "google_network_services_multicast_domain_activation" "multicast_domain_activation" {
  multicast_domain_activation_id                    = "test-domain-activation-mca-${local.name_suffix}"
  location = "us-central1-b"
  multicast_domain = google_network_services_multicast_domain.multicast_domain.id
}

resource "google_network_services_multicast_consumer_association" mca_test  {
  multicast_consumer_association_id              = "test-consumer-association-mca-${local.name_suffix}"
  location = "us-central1-b"
  network = google_compute_network.network.id
  multicast_domain_activation = google_network_services_multicast_domain_activation.multicast_domain_activation.id
  depends_on = [google_compute_network.network]
}
