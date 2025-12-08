resource "google_compute_network" "network" {
  name                    = "test-network-mgra-${local.name_suffix}"
  auto_create_subnetworks = false
}

resource "google_network_services_multicast_domain" "multicast_domain" {
  multicast_domain_id                    = "test-domain-mgra-${local.name_suffix}"
  location = "global"
  admin_network = google_compute_network.network.id
  connection_config  { connection_type="SAME_VPC"}
  depends_on = [google_compute_network.network]
}

resource "google_network_connectivity_internal_range" "internal_range" {
  name    = "test-internal-range-mgra-${local.name_suffix}"
  network = google_compute_network.network.self_link
  usage   = "FOR_VPC"
  peering = "FOR_SELF"
  ip_cidr_range = "224.2.0.2/32"
}

resource "google_network_services_multicast_group_range" "group_range" {
  multicast_group_range_id                   = "test-group-range-mgra-${local.name_suffix}"
  location = "global"
  reserved_internal_range = google_network_connectivity_internal_range.internal_range.id
  multicast_domain = google_network_services_multicast_domain.multicast_domain.id
}

resource "google_network_services_multicast_domain_activation" "multicast_domain_activation" {
  multicast_domain_activation_id                    = "test-domain-activation-mgra-${local.name_suffix}"
  location = "us-central1-b"
  multicast_domain = google_network_services_multicast_domain.multicast_domain.id
}

resource "google_network_services_multicast_group_range_activation" mgra_test {
  multicast_group_range_activation_id                   = "test-mgra-mgra-${local.name_suffix}"
  location = "us-central1-b"
  description = "my description"
  labels = {
    "test-label" = "test-value"
  }
  multicast_group_range = google_network_services_multicast_group_range.group_range.id
  multicast_domain_activation = google_network_services_multicast_domain_activation.multicast_domain_activation.id
}
